namespace Qemma.APP.Database.Models
{
    public class Chart<TKey, TValue>
    {
        public string Name { get; set; }
        public TValue[] Data { get; set; }
        public TKey[] Categories { get; set; }
    }

    public class ChartPoint<TKey, TValue>
    {
        public TValue Value { get; set; }
        public TKey Key { get; set; }
    }
}
