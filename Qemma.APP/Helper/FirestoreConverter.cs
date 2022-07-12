namespace Qemma.APP.Helper
{
    public class FirestoreConverter<T> : IFirestoreConverter<T> where T : new()
    {
        public object ToFirestore(T value)
        {
            return value?.ToDictionary() ?? new Dictionary<string, object>();
        }

        public T FromFirestore(object value)
        {
            if (value is not IDictionary<string, object> dict) return new T();
            var _ = dict.Where(kv => kv.Value is Timestamp).Set(kv =>
            {
                dict[kv.Key] = (kv.Value as Timestamp?)?.ToDateTime() ?? DateTime.MinValue;
            }).ToList();
            return dict.ToObject<T>();
        }
    }
}
