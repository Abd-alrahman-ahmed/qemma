namespace Qemma.APP.Database.Models
{
    [CollectionName("students")]
    [FirestoreData(ConverterType = typeof(FirestoreConverter<Student>), UnknownPropertyHandling = UnknownPropertyHandling.Ignore)]
    public class Student
    {
        public string Id { get; set; }
        public string Name { get; set; }
        public string PhoneNumber { get; set; }
        public Gender Gender { get; set; }
        public Year Year { get; set; }
        public double Degree { get; set; } = 0;
        public double TotalDegree { get; set; } = 0;
        public AccountStatus Status { get; set; }
        public DateTime RegistrationDate { get; set; }
        public List<string> GroupIds { get; set; } = new List<string>();
        public List<string> LessonIds { get; set; } = new List<string>(); // refrence to student lessons collection
    }
}
