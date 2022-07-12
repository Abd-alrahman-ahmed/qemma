namespace Qemma.APP.Extensions
{
    public static class StringExtensions
    {
        public static string CapitalizeFirstLetter(this string GenericString)
        {
            if (GenericString.Length == 0)
                return string.Empty;
            else if (GenericString.Length == 1)
                return char.ToUpper(GenericString[0]).ToString();
            else
                return char.ToUpper(GenericString[0]) + GenericString[1..];
        }

        public static string CapitalizeFirstLetterWithSplitter(this string GenericString, string splitter)
        {
            GenericString = GenericString.CapitalizeFirstLetter();
            return GenericString.Split(splitter).Aggregate((a, b) => $"{a}{splitter}{b.CapitalizeFirstLetter()}");
        }
    }
}
