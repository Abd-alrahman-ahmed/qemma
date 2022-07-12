namespace Qemma.APP.Database.Models
{
    [CollectionName("qemma_events")]
    [FirestoreData(ConverterType = typeof(FirestoreConverter<QemmaEvent>), UnknownPropertyHandling = UnknownPropertyHandling.Ignore)]
    public class QemmaEvent
    {
        public string Id { get; set; }
        public string TitleHtml { get; set; }
        public string BodyHtml { get; set; }
    }
}
