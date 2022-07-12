namespace Qemma.APP.Attributes
{
    [AttributeUsage(AttributeTargets.Class)]
    public class CollectionNameAttribute : Attribute
    {
        public string Name { get; }

        public CollectionNameAttribute(string Name = "")
        {
            this.Name = Name;
        }
    }
}