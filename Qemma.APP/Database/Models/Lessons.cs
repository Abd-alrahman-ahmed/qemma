namespace Qemma.APP.Database.Models
{
    [CollectionName("lessons")]
    [FirestoreData(ConverterType = typeof(FirestoreConverter<Lesson>), UnknownPropertyHandling = UnknownPropertyHandling.Ignore)]
    public class Lesson
    {
        public string Id { get; set; }
        public string Name { get; set; }
        public string TeacherName { get; set; }
        public DateTime Start { get; set; }
        public double QuizDegree { get; set; }
        public double HomeworkDegree { get; set; }
        public double InClassExamDegree { get; set; }
        public double BehaviourDegree { get; set; }
        public double InteractionDegree { get; set; }
        public string GroupId { get; set; }
        public List<string> StudentIds { get; set; }  // refrence to student lessons collection
    }
}
