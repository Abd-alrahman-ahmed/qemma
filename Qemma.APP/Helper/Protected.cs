using System.Security;
using System.Security.Cryptography;
using System.Text;

namespace Qemma.APP.Helper
{
    public static class Protected
    {
        private static readonly int saltSize = 20;
        private static readonly int saltPosition = 5;

        public static string Encrypt(string key, string plainText)
        {
            byte[] iv = new byte[16];
            byte[] array;

            using (Aes aes = Aes.Create())
            {
                aes.Key = Encoding.UTF8.GetBytes(key);
                aes.IV = iv;

                ICryptoTransform encryptor = aes.CreateEncryptor(aes.Key, aes.IV);

                using MemoryStream memoryStream = new MemoryStream();
                using CryptoStream cryptoStream = new CryptoStream(memoryStream, encryptor, CryptoStreamMode.Write);
                using (StreamWriter streamWriter = new StreamWriter(cryptoStream))
                {
                    streamWriter.Write(plainText);
                }

                array = memoryStream.ToArray();
            }

            return Convert.ToBase64String(array);
        }

        public static SecureString Decrypt(string key, string cipherText)
        {
            byte[] iv = new byte[16];
            byte[] buffer = Convert.FromBase64String(cipherText);
            string plainText;
            using (Aes aes = Aes.Create())
            {
                aes.Key = Encoding.UTF8.GetBytes(key);
                aes.IV = iv;
                ICryptoTransform decryptor = aes.CreateDecryptor(aes.Key, aes.IV);

                using MemoryStream memoryStream = new MemoryStream(buffer);
                using CryptoStream cryptoStream = new CryptoStream(memoryStream, decryptor, CryptoStreamMode.Read);
                using StreamReader streamReader = new StreamReader(cryptoStream);
                plainText = streamReader.ReadToEnd();
            }
            var result = new SecureString();
            foreach (char ch in plainText)
            {
                result.AppendChar(ch);
            }
            result.MakeReadOnly();
            return result;
        }

        public static string CreatePasswordHash(string pwd)
        {
            return CreatePasswordHash(pwd, CreateSalt());
        }

        public static bool Validate(string password, string passwordHash)
        {
            try
            {
                var salt = passwordHash.Substring(saltPosition, saltSize);
                var hashedPassword = CreatePasswordHash(password, salt);
                return hashedPassword == passwordHash;
            }
            catch (Exception)
            {
                return false;
            }
        }

        private static string CreatePasswordHash(string pwd, string salt)
        {
            string saltAndPwd = String.Concat(pwd, salt);
            string hashedPwd = GetHashString(saltAndPwd);
            hashedPwd = hashedPwd.Insert(saltPosition, salt);
            return hashedPwd;
        }

        private static string CreateSalt()
        {
            RNGCryptoServiceProvider rng = new RNGCryptoServiceProvider();
            try
            {
                byte[] buff = new byte[20];
                rng.GetBytes(buff);
                string salt = Convert.ToBase64String(buff);
                if (salt.Length > saltSize)
                {
                    salt = salt.Substring(0, saltSize);
                    return salt.ToUpper();
                }

                var saltChar = '^';
                salt = salt.PadRight(saltSize, saltChar);
                return salt.ToUpper();
            }
            finally
            {
                rng.Dispose();
            }
        }

        private static string GetHashString(string password)
        {
            StringBuilder sb = new StringBuilder();
            foreach (byte b in GetHash(password))
                sb.Append(b.ToString("X2"));

            return sb.ToString();
        }

        private static byte[] GetHash(string password)
        {
            SHA384 sha = new SHA384CryptoServiceProvider();
            try
            {
                return sha.ComputeHash(Encoding.UTF8.GetBytes(password));
            }
            finally
            {
                sha.Dispose();
            }
        }
    }
}