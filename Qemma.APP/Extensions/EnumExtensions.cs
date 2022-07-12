namespace Qemma.APP.Extensions
{
    public static class EnumExtensions
    {
        // This method requesting the Description MetaData attribute.
        public static string Description(this Enum GenericEnum)
        {
            Type genericEnumType = GenericEnum.GetType();
            MemberInfo[] memberInfo = genericEnumType.GetMember(GenericEnum.ToString());
            if (!memberInfo.IsNull() && memberInfo.Length > 0)
            {
                var _Attribs = memberInfo[0].GetCustomAttributes(typeof(DescriptionAttribute), false);
                if (!_Attribs.IsNull() && _Attribs.Count() > 0)
                {
                    return ((DescriptionAttribute)_Attribs.ElementAt(0)).Description;
                }
            }
            return GenericEnum.ToString();
        }

        public static IEnumerable<string> GetDescriptions<T>()
        {
            var type = typeof(T);
            var names = Enum.GetNames(type);
            foreach (var name in names)
            {
                var field = type.GetField(name);
                var attributes = field.GetCustomAttributes(typeof(DescriptionAttribute), false);
                foreach (DescriptionAttribute attribute in attributes)
                {
                    yield return attribute.Description;
                }
            }
        }

        public static T GetAttribute<T>(this Enum GenericEnum) where T : Attribute
        {
            var type = GenericEnum.GetType();
            var memInfo = type.GetMember(GenericEnum.ToString()).FirstOrDefault();
            var attributes = memInfo?.GetCustomAttributes(typeof(T), false);
            return (T)attributes?.FirstOrDefault();
        }
    }
}
