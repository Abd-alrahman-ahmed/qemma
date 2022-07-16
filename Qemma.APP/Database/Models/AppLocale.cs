namespace Qemma.APP.Database.Models
{
    [CollectionName("locales")]
    [FirestoreData(ConverterType = typeof(FirestoreConverter<AppLocale>), UnknownPropertyHandling = UnknownPropertyHandling.Ignore)]
    public class AppLocale
    {
        public string Id { get; set; }
        public string Code { set; get; }
        public bool Rtl { set; get; }
        public bool Supported { set; get; }
        public string? CountryCode { set; get; }
        public Dictionary<string, string> Translations { set; get; }
    }

}
