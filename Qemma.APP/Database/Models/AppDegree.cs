namespace Qemma.APP.Database.Models
{
    [CollectionName("degrees_range")]
    [FirestoreData(ConverterType = typeof(FirestoreConverter<AppDegree>), UnknownPropertyHandling = UnknownPropertyHandling.Ignore)]
    public class AppDegree
    {
        public string Id { get; set; }
        public string TranslationKey { set; get; }
        public double Min { get; set; }
    }
}
