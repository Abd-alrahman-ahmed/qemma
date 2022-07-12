namespace Qemma.APP.Database.Models
{
    [CollectionName("qemma_groups")]
    [FirestoreData(ConverterType = typeof(FirestoreConverter<Group>), UnknownPropertyHandling = UnknownPropertyHandling.Ignore)]
    public class Group
    {
        public string Id { get; set; }
        public string Name { get; set; }
        public string Subject { get; set; }
        public Year Year { get; set; }
        public List<GroupDates> Dates { get; set; }
        public double Price { get; set; }
        public List<string> StudentIds { get; set; }
        public List<string> LessonIds { get; set; }
    }

    [FirestoreData(ConverterType = typeof(FirestoreConverter<GroupDates>), UnknownPropertyHandling = UnknownPropertyHandling.Ignore)]
    public class GroupDates
    {
        public DayOfWeek Day { get; set; }
        public DateTime StartTime { get; set; }
    }
}
