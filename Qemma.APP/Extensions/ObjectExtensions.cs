using System.Collections;

namespace Qemma.APP.Extensions
{
    public static class ObjectExtensions
    {
        public static string GetCollectionName(this Type type)
        {
            if (type.GetCustomAttributes(typeof(CollectionNameAttribute), true)
                .FirstOrDefault() is CollectionNameAttribute collectionAttribute)
            {
                return collectionAttribute.Name;
            }
            return null;
        }

        public static bool IsNull(this object obj)
        {
            return obj is null;
        }

        public static T ToObject<T>(this IDictionary<string, object> source)
        {
            var serialized = JsonSerializer.Serialize(source) ?? "{}";
            return JsonSerializer.Deserialize<T>(serialized, new JsonSerializerOptions
            {
                PropertyNameCaseInsensitive = true
            });
        }

        public static IDictionary<string, object> ToDictionary(this object source)
        {
            var dictionary = new Dictionary<string, object>();

            foreach (PropertyDescriptor property in TypeDescriptor.GetProperties(source))
                AddPropertyToDictionary(property.Name, property.GetValue(source), property.PropertyType, dictionary);
            
            return dictionary;
        }

        private static void AddPropertyToDictionary(string key, object value, Type propertyType, Dictionary<string, object> dictionary)
        {
            if (value == null) return;
            key = JsonNamingPolicy.CamelCase.ConvertName(key);
            if (value is IList list)
            {
                var newList = new List<object>();
                for (int i = 0; i < list.Count; i++)
                {
                    propertyType = list[i].GetType();
                    if (propertyType.IsClass && propertyType != typeof(string))
                        newList.Add(list[i].ToDictionary());
                    else
                        newList.Add(list[i]);
                }
                dictionary.Add(key, newList);
            }
            else if (value is not IDictionary && propertyType.IsClass && propertyType != typeof(string))
                dictionary.Add(key, value.ToDictionary());
            else
                dictionary.Add(key, value);
        }
    }
}
