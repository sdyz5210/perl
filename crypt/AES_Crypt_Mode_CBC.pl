#! /usr/bin/perl

use strict;
use Crypt::Mode::CBC;
use MIME::Base64;

=crypt-mode-cdc
	Crypt::Mode::CBC模块的学习
	根据比较该模块要比Crypt-CBC模块加密效率要高很多，该模块的加密和解密完全可以和java进行匹配
=cut

sub encryptString{
	my $key = "1234567890abcdef";
	my $iv = "abcdef0123456789" ;
	my $str = "Hello World!!!";
	my $cipher = Crypt::Mode::CBC->new('AES');

	my $str_en = $cipher->encrypt($str,$key,$iv);
	print encode_base64($str_en);
	print "\n";
	my $str_de = $cipher->decrypt($str_en,$key,$iv);
	print "$str_de";
}

sub encryptFile{
	my $key = "1234567890abcdef";
	my $iv = "abcdef0123456789" ;
	my $sourceFile = "/Users/mac/Documents/data/bactive/MiLib114_S3_L001_R1_001.fastq.gz";
	my $destFile = "/Users/mac/Documents/data/bactive/004.fastq.gz.aes" ;
	open(DATA1,"<$sourceFile") or die "文件无法打开, $!";
	binmode(DATA1);
	open(DATA2,">$destFile") or die "文件无法打开, $!";
	binmode(DATA2);

	my $cipher = Crypt::Mode::CBC->new('AES');
	my $buffer = undef;
	my $buffer_size = 64*1024;
	$cipher->start_encrypt($key, $iv);
	while (read(DATA1,$buffer,$buffer_size)) {
		print DATA2 $cipher->add($buffer);
	}
	print DATA2 $cipher->finish();
	close(DATA1);
	close(DATA2);
}

sub decryptFile{
	my $key = "1234567890abcdef";
	my $iv = "abcdef0123456789" ;
	my $sourceFile = "/Users/mac/Documents/data/bactive/004.fastq.gz.aes";
	my $destFile = "/Users/mac/Documents/data/bactive/004.fastq.gz" ;
	open(DATA1,"<$sourceFile") or die "文件无法打开, $!";
	binmode(DATA1);
	open(DATA2,">$destFile") or die "文件无法打开, $!";
	binmode(DATA2);

	my $cipher = Crypt::Mode::CBC->new('AES');
	my $buffer = undef;
	my $buffer_size = 64*1024;
	$cipher->start_decrypt($key, $iv);
	while (read(DATA1,$buffer,$buffer_size)) {
		print DATA2 $cipher->add($buffer);
	}
	print DATA2 $cipher->finish();
	close(DATA1);
	close(DATA2);
}

#encryptString();
encryptFile();
decryptFile();

=java
	以下附录java代码：

	public static void encryptFile(String sourceFilePath, String destFilePath, String key, String ivParameter) {
		File sourceFile = new File(sourceFilePath);
		File destFile = new File(destFilePath);
		if (sourceFile.exists() && sourceFile.isFile()) {
			if (!destFile.getParentFile().exists()) {
				destFile.getParentFile().mkdirs();
			}
			try {
				destFile.createNewFile();
				InputStream in = new FileInputStream(sourceFile);
				OutputStream out = new FileOutputStream(destFile);
				// 转换为AES专用密钥
				SecretKeySpec secretKeySpec = new SecretKeySpec(key.getBytes(), "AES");
				IvParameterSpec iv = new IvParameterSpec(ivParameter.getBytes());
				// 创建密码器
				Cipher cipher = Cipher.getInstance("AES/CBC/PKCS5Padding");
				cipher.init(Cipher.ENCRYPT_MODE, secretKeySpec, iv);
				CipherInputStream cin = new CipherInputStream(in, cipher);
				byte[] cache = new byte[1024];
				int nRead = 0;
				while ((nRead = cin.read(cache)) != -1) {
					out.write(cache, 0, nRead);
					out.flush();
				}
				out.close();
				cin.close();
				in.close();
			} catch (IOException e) {
				e.printStackTrace();
			} catch (NoSuchAlgorithmException e) {
				e.printStackTrace();
			} catch (NoSuchPaddingException e) {
				e.printStackTrace();
			} catch (InvalidKeyException e) {
				e.printStackTrace();
			} catch (InvalidAlgorithmParameterException e) {
				e.printStackTrace();
			}
		}
	}

	public static void decryptFile(String sourceFilePath, String destFilePath, String key, String ivParameter) {
		File sourceFile = new File(sourceFilePath);
		File destFile = new File(destFilePath);
		if (sourceFile.exists() && sourceFile.isFile()) {
			if (!destFile.getParentFile().exists()) {
				destFile.getParentFile().mkdirs();
			}
			try {
				destFile.createNewFile();
				InputStream in = new FileInputStream(sourceFile);
				OutputStream out = new FileOutputStream(destFile);
				// 转换为AES专用密钥
				SecretKeySpec secretKeySpec = new SecretKeySpec(key.getBytes(), "AES");
				IvParameterSpec iv = new IvParameterSpec(ivParameter.getBytes());
				// 创建密码器
				Cipher cipher = Cipher.getInstance("AES/CBC/PKCS5Padding");
				cipher.init(Cipher.DECRYPT_MODE, secretKeySpec, iv);
				CipherOutputStream cout = new CipherOutputStream(out, cipher);
				byte[] cache = new byte[1024];
				int nRead = 0;
				while ((nRead = in.read(cache)) != -1) {
					cout.write(cache, 0, nRead);
					cout.flush();
				}
				cout.close();
				out.close();
				in.close();
			} catch (IOException e) {
				e.printStackTrace();
			} catch (NoSuchAlgorithmException e) {
				e.printStackTrace();
			} catch (NoSuchPaddingException e) {
				e.printStackTrace();
			} catch (InvalidKeyException e) {
				e.printStackTrace();
			} catch (InvalidAlgorithmParameterException e) {
				e.printStackTrace();
			}
		}
	}
=cut 