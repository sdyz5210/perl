#! /usr/bin/perl

use strict;
use Crypt::Mode::ECB;
use MIME::Base64;

=aes
	学习使用Crypt_Mode_ECB模块。使用该模块加密/解密文件，同时实现java加密/解密对应perl的解密/加密
	后附录java代码
=cut

sub encryptString{
	my $key = "1234567890abcdef";
	my $str = "Hello World!!!";
	my $cipher = Crypt::Mode::ECB->new('AES');

	my $str_en = $cipher->encrypt($str,$key);
	print encode_base64($str_en);
	my $str_de = $cipher->decrypt($str_en,$key);
	print "$str_de\n";
}

sub encryptFile{
	my $sourceFile = "/Users/mac/Documents/data/bactive/MiLib114_S3_L001_R1_001.fastq.gz";
	my $destFile = "/Users/mac/Documents/data/bactive/004.fastq.gz.aes" ;
	open(DATA1,"<$sourceFile") or die "文件无法打开, $!";
	binmode(DATA1);
	open(DATA2,">$destFile") or die "文件无法打开, $!";
	binmode(DATA2);

	my $key = "1234567890abcdef";
	my $cipher = Crypt::Mode::ECB->new('AES');
	my $buffer = undef;
	my $buffer_size = 64*1024;
	$cipher->start_encrypt($key);
	while (read(DATA1,$buffer,$buffer_size)) {
		print DATA2 $cipher->add($buffer);
	}
	print DATA2 $cipher->finish();
	close(DATA1);
	close(DATA2);
}

sub decryptFile{
	my $key = "1234567890abcdef";
	my $sourceFile = "/Users/mac/Documents/data/bactive/004.fastq.gz.aes";
	my $destFile = "/Users/mac/Documents/data/bactive/004.fastq.gz" ;
	open(DATA1,"<$sourceFile") or die "文件无法打开, $!";
	binmode(DATA1);
	open(DATA2,">$destFile") or die "文件无法打开, $!";
	binmode(DATA2);

	my $cipher = Crypt::Mode::ECB->new('AES');
	my $buffer = undef;
	my $buffer_size = 64*1024;
	$cipher->start_decrypt($key);
	while (read(DATA1,$buffer,$buffer_size)) {
		print DATA2 $cipher->add($buffer);
	}
	print DATA2 $cipher->finish();
	close(DATA1);
	close(DATA2);
}

encryptString();
#encryptFile();
#decryptFile();


=java
	
	public static void encryptFile(String sourceFilePath, String destFilePath, String key) {
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
				// 创建密码器
				Cipher cipher = Cipher.getInstance("AES/ECB/PKCS5Padding");
				cipher.init(Cipher.ENCRYPT_MODE, secretKeySpec);
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
			}
		}
	}

	public static void decryptFile(String sourceFilePath, String destFilePath, String key) {
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
				// 创建密码器
				Cipher cipher = Cipher.getInstance("AES/ECB/PKCS5Padding");
				cipher.init(Cipher.DECRYPT_MODE, secretKeySpec);
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
			}
		}
	}
=cut