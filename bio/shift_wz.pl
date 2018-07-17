#!/usr/local/bin/perl 
# 
# 
# Ver 2.0 by 
# Eyal Seroussi <seroussi@agri.huji.ac.il> 
# Darek Kedra   <darked@burnham.org> 
# 
# 
#-------------------------------------------------------------------- 
#these three  are platform dependent: 
# 
my $home="/share/biosoft/perl/liys/software/diagnosis";
my $PHRED_EXE  =  "$home/bin/phred"; 
my $PHRED_DAT  =  "$home/bin/phredpar.dat"; 
my $temp_path  =  "tmp/";
system("mkdir $temp_path") unless (-d "$temp_path");
# default values possible to be modified 
my $MIN_SHIFT_SIZE  =  1; 
my $MAX_SHIFT_SIZE  =  25; 
#-------------------------------------------------------------------- 
unless (@ARGV == 4) 
{ 
#print  
#"Usage: frsh tracefile user_name expect first-base last-base 
#Takes a single trace file created by ABI and looks for a frameshift. 
#Out-put includes frameshift size and the putative sequence of the molecule. 
#EOH 
#exit 0;" 
#} 
#unless ($ARGV[3] < $ARGV[4]) 
#{ 
#print "EOH; 
#Wrong cut-off data. 
#EOH 
#exit 0; "
} 
#-------------------------------------------------------------------- 
#main 
#adjusting working environment 
my $ABI_file    = $ARGV[0]; 
my $file_suffix = $ARGV[1]; 
my $expect      = $ARGV[2]; 
my $fbase       = $ARGV[3]; 
#my $lbase       = $ARGV[4]; 
my $temp_ABI_file   =  "$temp_path".'frshtrace'."$file_suffix"; 
my $temp_poly_file  = "$temp_ABI_file".'.poly';
my $temp_quality_file  = "$temp_ABI_file".'.qual';
my $temp_seq_file  = "$temp_ABI_file".'.seq';
my $fof_name = "$temp_path"."$file_suffix".'.fof'; 
system("rm -f $fof_name"); 
system("touch $fof_name"); 
system("cp $ABI_file $temp_ABI_file"); 
run_phred(); 
read_poly(); 
#Screen for shifts in range of 1 to 25 bases using Check_Shift subroutine 
for ($shift_size = $MIN_SHIFT_SIZE; $shift_size <= $MAX_SHIFT_SIZE; $shift_size++ ) 
    { 
     Check_Shift(); 
     print "\n"; 
    } 
#main ends 
#-------------------------------------------------------------------- 
sub run_phred 
#-------------------------------------------------------------------- 
{ 
$ENV{PHRED_PARAMETER_FILE} = $PHRED_DAT; 
#system("$PHRED_EXE -dd $temp_path -process_nomatch $temp_ABI_file"); 
system("$PHRED_EXE -dd $temp_path  $temp_ABI_file -process_nomatch -s $temp_seq_file -q $temp_quality_file -trim_alt \"\" -trim_cutoff 1"); 
#system("$PHRED_EXE -dd $temp_path  $temp_ABI_file -process_nomatch -s $temp_path/$temp_seq_file -q $temp_path/$temp_quality_file -trim_alt \"\" -trim_cutoff 1"); 
}#sub run_phred ends 
#system("$PHRED_EXE -dd $temp_path -process_nomatch $temp_ABI_file"); 
#-------------------------------------------------------------------- 
sub read_poly 
#-------------------------------------------------------------------- 
{ 
open(POLY_FILE,"$temp_poly_file") or die $!; 
my @POLY_FILE_ARRAY = <POLY_FILE>; 
close POLY_FILE; 
shift @POLY_FILE_ARRAY; 
my $base_number = 1; 
for (@POLY_FILE_ARRAY) 
    { 
    #preparing bases for comparison 
    @line_record = split /  /; 
    if ($base_number <= $#POLY_FILE_ARRAY-20) 
       { 
       if ($base_number >= $fbase) 
          { 
           my $pbase_number= $base_number-$fbase+1; 
           $base1[$pbase_number]    = $line_record[0]; 
           $base1_ra[$pbase_number] = $line_record[3]; 
           $base2[$pbase_number]    = $line_record[4]; 
           $base2_ra[$pbase_number] = $line_record[7]; 
           if ($base2[$pbase_number] eq "N") 
              { 
              $base2[$pbase_number]    = $base1[$pbase_number]; 
              $base2_ra[$pbase_number] = $base1_ra[$pbase_number]; 
              } 
          } 
       } 
    $base_number++; 
    } #end for (@POLY_FILE_ARRAY) 
}#sub read_poly ends 
#-------------------------------------------------------------------- 
sub Check_Shift 
#-------------------------------------------------------------------- 
{ 
for (my $base_number = 1; $base_number < $#base1; $base_number++) 
    { 
    $prediction1[$base_number]     = $prediction2[$base_number]    = "N"; 
    $prediction1_ra[$base_number]  = $prediction2_ra[$base_number] = $taken[$base_number] = 0; 
    } 
#The @taken array acts as an array of flags. If a base was taken to 
#prediction 1 the program should know it in the future to improve its predictions. 
for  ($base_number = 1; $base_number < $#base1; $base_number++) 
     { 
     #Making the match across $shift_size, if there is one, it is stored in the 
     #prediction sequences: 
     #there are 4 possibilities for each position: A, B, C, D. 
     #start matching only if the molecule is long enough. (4 possibilities:) 
     if ($base_number > $shift_size + 1 ) 
        { 
        #(long enough:) 
        my $offset_base_no = $base_number - $shift_size; 
        my $current_base1 = $base1[$base_number]; 
        my $current_base1_ra = $base1_ra[$base_number]; 
        my $current_base2 = $base2[$base_number]; 
        my $current_base2_ra = $base2_ra[$base_number]; 
########################################################################### 
        #A- the first bases of the 2 calls are identical B- the first base and the second one are equal: 
        if (($current_base1 eq $base1[$offset_base_no]) or ($current_base1 eq $base2[$offset_base_no])) 
           { 
           #(possibility A and B:) 
           $prediction1[$base_number]    = $current_base1; 
           $prediction1_ra[$base_number] = $current_base1_ra; 
           $prediction2[$base_number]    = $current_base2; 
           $prediction2_ra[$base_number] = $current_base2_ra; 
           $taken[$base_number] = 1; 
           }#(possibility A and B) 
        #C- the second base and the first one are equal: 
        #should be checked only if there is a real double peak at the first call 
        if ($current_base2 ne $current_base1) 
           { 
           #(double peak:) 
           if ($current_base2 eq $base1[$offset_base_no]) 
              { 
              #(possibility C:) 
              if ($prediction1[$base_number] ne "N") 
                 { 
                 #if there is no "N" there is already prediction for that base. 
                 #it means that there are 2 logical predictions for this 
                 #base and the program annotates that using the word "or" 
                 #the program then try to decide which is better and put it in first place 
                 #it takes into consideration if the base from the second call has 
                 #already been assigned (two solutions by C:) 
                 if ($taken[$offset_base_no] == 0) 
                    { 
                    #if the "taken" flag is not raised it means that both bases are possible and 
                    #the high quality one will be first (not taken:) 
                    $prediction1[$base_number] = $prediction1[$base_number].' or '.$current_base2; 
                    $prediction2[$base_number] = $prediction1[$base_number]; 
                    }#not taken 
                    else 
                       { 
                       #if the "taken" flag is raised it is less likely that base 1 is the 
                       #right one as it is already taken to another position 
                       #and the places should be switched unless the quality  of that second 
                       #base is really dubious (taken) 
                       if (($base1_ra[$offset_base_no] / $base2_ra[$offset_base_no])>30) 
                          { 
                          #quality dubious don't switch 
                          $prediction1[$base_number] = $prediction1[$base_number].' or '.$current_base2; 
                          $prediction2[$base_number] = $prediction1[$base_number]; 
                          } 
                       else 
                          { 
                          #quality OK to switch 
                          $prediction1[$base_number] = $current_base2.' or '.$prediction1[$base_number]; 
                          $prediction2[$base_number] = $prediction1[$base_number]; 
                          } 
                       }#taken 
                 }#two solutions by C 
                 else 
                    { 
                    #(one solution by C:) 
                    $prediction1[$base_number]    = $current_base2; 
                    $prediction1_ra[$base_number] = $current_base2_ra; 
                    $prediction2[$base_number]    = $current_base1; 
                    $prediction2_ra[$base_number] = $current_base1_ra; 
                    $taken[$base_number] = 1; 
                    }#(one solution by C) 
              }#(possibility C ends) 
              #D- the second bases of the 2 calls are identical: 
              if ($base1[$offset_base_no] ne $base2[$offset_base_no]) 
                 { 
                 #(double peak in second call:) 
                 if ($current_base2 eq $base2[$offset_base_no]) 
                    { 
                    #(possibility D:) 
                    if ($prediction1[$base_number] ne "N") 
                       { 
                       #(two solutions by D:) 
                       if ($taken[$offset_base_no] == 0) 
                          { 
                          $prediction1[$base_number] = $prediction1[$base_number].' or '.$current_base2; 
                          $prediction2[$base_number] = $prediction1[$base_number]; 
                          } 
                       else 
                          { 
                          if (($base1_ra[$offset_base_no]/$base2_ra[$offset_base_no])>30) 
                             { 
                             $prediction1[$base_number] = $prediction1[$base_number].' or '.$current_base2; 
                             $prediction2[$base_number] = $prediction1[$base_number]; 
                             } 
                          else { 
                               $prediction1[$base_number] = $current_base2.' or '.$prediction1[$base_number]; 
                               $prediction2[$base_number] = $prediction1[$base_number]; 
                               } 
                          } 
                       }#(two solutions by D) 
                       else 
                          { 
                          #(one solution by D:) 
                          $prediction1[$base_number] = $current_base2; 
                          $prediction1_ra[$base_number] = $current_base2_ra; 
                          $prediction2[$base_number] = $current_base1; 
                          $prediction2_ra[$base_number] = $current_base1_ra; 
                          $taken[$base_number] = 1; 
                          }#(one solution by D) 
                    }#(possibility D ends) 
                 }#(double peak in second call) 
           }#(double peak) 
        }#(long enough) 
        #changing the format to single letter format 
        $prediction1[$base_number] = single_letter_code($prediction1[$base_number]); 
        $prediction2[$base_number] = single_letter_code($prediction2[$base_number]); 
     }#(4 possibilities:) 
     calc_probability(); 
}# sub Check_Shift ends 
########################################################################### 
#-------------------------------------------------------------------- 
sub calc_probability 
#-------------------------------------------------------------------- 
{ 
#finding the site of shift 
#preparing working environment, the variable min_shift_pro indicates the existence 
#of a shift when small than 0.001. It is calculated for each position by comparing 
#prediction 1 and 2 across the shift. Since the chance to a similar pair is 0.25 
#(4 pairs of 16 possibilities) this variable is divided by 4 when a match 
#is encountered. This variable is multiplied by 4, which is an empirical penalty 
#value for a mismatch. A fail to predict (letter N in prediction) is 
#regarded as a mismatch. 
my $shift_found = 'none'; 
my $min_probab_found   = 'none'; 
my $min_shift_pro  = 1; 
for ( my $base_number = 1; ($base_number  < $#prediction1 - (10 + $shift_size));  $base_number++) 
    { 
    #(estimating min_shift_pro:) 
    $probability[$base_number] = 1; 
    for (my $base_offset = 0; $base_offset < 10; $base_offset++ ) 
        { 
        #estimating shift probability p[$base_number] by 10 bases 
        if ($prediction1[$base_number + $shift_size + $base_offset] eq 'N') 
           { 
           $probability[$base_number] = $probability[$base_number]*4; 
           } 
        else 
           { 
           if ($prediction1[$base_number + $shift_size + $base_offset] eq $prediction2[$base_number + $base_offset]) 
              { 
              $probability[$base_number] = $probability[$base_number]*0.25; 
              } 
           else 
              { 
              $probability[$base_number] = $probability[$base_number]*4; 
              } 
           } 
        } 
        # print "$base_number p=$probability[$base_number]\n"; 
        if ($probability[$base_number] < $min_shift_pro) 
           { 
           $min_shift_pro = $probability[$base_number]; 
           if ($probability[$base_number] < 0.001) 
              { 
              $shift_found = 'yes'; 
              } 
           } 
        if ($min_probab_found eq 'none') 
           { 
           if ($shift_found eq 'yes') 
              { 
              if ($probability[$base_number] >= $probability[$base_number-1]) 
                 { 
                 $min_probab_found = 'yes'; 
                 #recording the site of shift to be reported 
                 $shift_start_pro = $probability[$base_number]; 
                 $shift_start = $base_number + $shift_size; 
                 } 
              } 
           } 
    }#(estimating min_shift_pro ends) 
################################################################################### 
#print summary 
#result are reported only if $min_shift_pro is less then expect value somewhere 
#along the predicted molecule. However 
#in such case the start of shift will be reported at first place 
#that probability dropped below 0.001 
$f_min_shift_pro = sprintf "%0.2e",$min_shift_pro; 
if ($min_shift_pro > $expect) {$shift_found = 'none';} 
if ($shift_found eq 'yes') 
   { 
   $f_min_shift_pro = sprintf "%0.2e",$min_shift_pro; 
   $f_shift_start_pro = sprintf "%0.2e",$shift_start_pro; 
   print "Shift of $shift_size nucleotides was detected (Expect $f_min_shift_pro)\n"; 
   #print "Shift starts at analyzed base $shift_start : probability score $f_shift_start_pro\n";
   printf "Shift starts at analyzed base %d : probability score $f_shift_start_pro\n",$shift_start+$fbase-1;
   print "The predicted sequence of the molecule following the shift is:\n"; 
   $fasta_file="$temp_path".$file_suffix.'_'."$shift_size".'.fasta'; 
   open (FASTA_FILE,"> $fasta_file") or die $!; 
   print {FASTA_FILE} "> $file_suffix.$shift_size\n"; 
   for ($i = $shift_start + 1; $i < $#prediction1; $i++) 
       { 
       print "$prediction1[$i]"; 
       print {FASTA_FILE} "$prediction1[$i]"; 
       if ((($i - $shift_start) % 60) == 0){print {FASTA_FILE} "\n"; print "\n";} 
       } 
   print{FASTA_FILE} "\n"; 
   print "\n"; 
   close FASTA_FILE; 
   $ID = "$file_suffix".'_'."$shift_size"; 
   fasta2exp($fasta_file, $ID); 
   } 
else 
   { 
   print "Checks for $shift_size nucleotide shift : No shift found (Expect $f_min_shift_pro)\n"; 
   } 
} #sub calc_probability ends 
#-------------------------------------------------------------------- 
sub single_letter_code 
#-------------------------------------------------------------------- 
{ 
my $input_base = $_[0]; 
my %bases_hash = 
  ( 
  'A or G'  =>  "R", 
  'G or A'  =>  "r", 
  'A or C'  =>  "M", 
  'C or A'  =>  "m", 
  'A or T'  =>  "W", 
  'T or A'  =>  "w", 
  'C or G'  =>  "S", 
  'G or C'  =>  "s", 
  'C or T'  =>  "Y", 
  'T or C'  =>  "y", 
  'G or T'  =>  "K", 
  'T or G'  =>  "k", 
  'A'       =>  'A', 
  'C'       =>  'C', 
  'G'       =>  'G', 
  'T'       =>  'T', 
  'N'       =>  'N' 
  ); 
if (exists ($bases_hash{$input_base})) 
   { 
   $output_base = $bases_hash{$input_base}; 
   } 
else 
   { 
    print "single_letter_code_sub -> bad base: $input_base\n" 
   } 
return $output_base; 
}#sub single_letter_code ends 
#-------------------------------------------------------------------- 
sub fasta2exp 
#-------------------------------------------------------------------- 
{ 
my ($fasta_file, $ID) = @_; 
my $exp_file = "$temp_path"."$ID".'.exp'; 
%IUPAC_hash = 
 ( 
 #iupac base, regular base, tag 
 'R' => ['A' , 'A or G'], 
 'r' => ['G' , 'A or G'], 
 'M' => ['A' , 'A or C'], 
 'm' => ['C' , 'A or C'], 
 'H' => ['N' , 'C,A or T  '], 
 'h' => ['N' , 'C,A or T  '], 
 'W' => ['A' , 'A or T'], 
 'w' => ['T' , 'A or T'], 
 'D' => ['N' , 'A,G or T  '], 
 'd' => ['N' , 'A,G or T  '], 
 'S' => ['C' , 'C or G'], 
 's' => ['G' , 'C or G'], 
 'B' => ['N' , 'C,G or T  '], 
 'b' => ['N' , 'C,G or T  '], 
 'Y' => ['C' , 'C or T'], 
 'y' => ['T' , 'C or T'], 
 'N' => ['N' , 'A,G,T or C'], 
 'n' => ['N' , 'A,G,T or C'], 
 'K' => ['G' , 'G or T'], 
 'k' => ['T' , 'G or T'], 
 'V' => ['N' , 'A,C or G  '], 
 'v' => ['N' , 'A,C or G  '], 
 'A' => ['A' , 'none' ], 
 'C' => ['C' , 'none' ], 
 'G' => ['G' , 'none' ], 
 'T' => ['T' , 'none' ] 
 ); 
open (FASTA_FILE, $fasta_file) or die $!; 
my @fasta_lines = <FASTA_FILE>; 
close FASTA_FILE; 
shift @fasta_lines; 
my (@exp_tags, @exp_sequence); 
for (@fasta_lines) 
    { 
    chomp; 
    @input_bases = split //; 
    for my $input_base (@input_bases) 
        { 
        if (exists ($IUPAC_hash{$input_base})) 
           { 
           my @values = @{$IUPAC_hash{$input_base}}; 
           my $output_base = $values[0]; 
           my $output_tag  = $values[1]; 
           push @exp_sequence, $output_base; 
           push @exp_tags, $output_tag; 
           } 
        else {print " fasta2exp: bad base: $input_base\n"} 
        } 
    } 
$exp[0]= 'ID   '."$ID"; 
$exp[1]= 'EN   '."$ID"; 
$exp[2]= 'LN   '."$ID"; 
$exp[3]= 'LT   PLN'; 
$exp[4]= 'QR   '."$#exp_sequence"; 
$exp[5]= 'AQ   0.000000'; 
$exp[6]= 'SQ'; 
$exp[7]= '     '; 
$line_exp_no = 7; 
for ($i = 1; $i <= $#exp_sequence; $i++) 
    { 
    $exp[$line_exp_no] = "$exp[$line_exp_no]"."$exp_sequence[$i]"; 
    if (($i % 60) == 0) 
       { 
       $line_exp_no++; 
       $exp[$line_exp_no]='     '; 
       } 
    elsif (($i % 10) == 0){$exp[$line_exp_no] = "$exp[$line_exp_no]".' '; } 
    } 
$line_exp_no++; 
$exp[$line_exp_no] = '//'; 
for ($i = 1; $i <= $#exp_sequence; $i++) 
    { 
    if ($exp_tags[$i] ne 'none') 
       { 
       $line_exp_no++; 
       $exp[$line_exp_no] = 'TG   COMM + '."$i".'..'."$i"; 
       $line_exp_no++; 
       $exp[$line_exp_no] = 'TG        '."$exp_tags[$i]"; 
       } 
    } 
open (EXP_FILE,">$exp_file") or die $!; 
for (@exp) 
    { 
    print {EXP_FILE} "$_"; 
    print {EXP_FILE} "\n"; 
    } 
close EXP_FILE; 
open (FOF_FILE,">>$fof_name") or die $!; 
print {FOF_FILE} "$ID\n"; 
close FOF_FILE; 
} #sub fasta2exp ends 