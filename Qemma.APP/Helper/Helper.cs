namespace Qemma.APP.Helper
{
    public static class Helper
    {
        public static bool TryConvert(object value, Type type, out object result)
        {
            try
            {
                if (type.IsEnum)
                {
                    var _value = Convert.ChangeType(value, typeof(int));
                    result = Enum.ToObject(type, _value);
                }
                else
                {
                    result = Convert.ChangeType(value, type);
                }
                return true;
            }
            catch (Exception)
            {
                result = null;
                return false;
            }
        }

        public static Type GetPropertyType<T>(string propertyName)
        {
            var type = typeof(T);
            foreach (var prop in propertyName.Split('.').Select(s => type.GetProperty(s)))
            {
                if (prop is null) return null;
                type = prop.PropertyType;
            }

            type = Nullable.GetUnderlyingType(type) ?? type;
            return type;
        }

        public static PropertyInfo GetPropertyInfo<T>(string propertyName)
        {
            return typeof(T).GetProperty(propertyName);
        }
    }
}
