namespace Qemma.APP.Database.Models
{
    [CollectionName("qemma_admin")]
    [FirestoreData(ConverterType = typeof(FirestoreConverter<Account>), UnknownPropertyHandling = UnknownPropertyHandling.Ignore)]
    public class Account
    {
        public string Id { get; set; }
        public string Username { get; set; }
        public string Password { get; set; }
    }
}
