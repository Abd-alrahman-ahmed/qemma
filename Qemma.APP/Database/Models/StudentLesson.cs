namespace Qemma.APP.Database.Models
{
    [CollectionName("student_lessons")]
    [FirestoreData(ConverterType = typeof(FirestoreConverter<StudentLesson>), UnknownPropertyHandling = UnknownPropertyHandling.Ignore)]
    public class StudentLesson
    {
        public string Id { get; set; }
        public DateTime Start { get; set; }
        public string StudentId { get; set; }
        public Student Student { get; set; }
        public string GroupId { get; set; }
        public string LessonId { get; set; }
        public Lesson Lesson { get; set; }
        public double QuizDegree { get; set; }
        public double HomeworkDegree { get; set; }
        public double InClassExamDegree { get; set; }
        public double BehaviourDegree { get; set; }
        public double InteractionDegree { get; set; }
        public bool HasAttend { get; set; }
        public double PaidAmount { get; set; }
    }
}
