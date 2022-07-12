using System.Collections;
using System.Collections.Generic;

namespace Qemma.APP.Helper
{
    public static class PredicateBuilder
    {
        public static Expression<Func<T, bool>> True<T>() { return f => true; }
        public static Expression<Func<T, bool>> False<T>() { return f => false; }

        public static Expression<Func<T, bool>> Or<T>(this Expression<Func<T, bool>> expr1,
                                                            Expression<Func<T, bool>> expr2)
        {
            var invokedExpr = Expression.Invoke(expr2, expr1.Parameters.Cast<Expression>());
            return Expression.Lambda<Func<T, bool>>
                  (Expression.OrElse(expr1.Body, invokedExpr), expr1.Parameters);
        }

        public static Expression<Func<T, bool>> And<T>(this Expression<Func<T, bool>> expr1,
                                                             Expression<Func<T, bool>> expr2)
        {
            var invokedExpr = Expression.Invoke(expr2, expr1.Parameters.Cast<Expression>());
            return Expression.Lambda<Func<T, bool>>
                  (Expression.AndAlso(expr1.Body, invokedExpr), expr1.Parameters);
        }

        private static Expression CreateExpression(ParameterExpression param, string propertyName)
        {
            Expression body = param;
            foreach (var member in propertyName.Split('.'))
            {
                body = Expression.PropertyOrField(body, member);
            }
            return body;
        }

        public static Expression<Func<T, bool>> Equal<T>(string property, object value)
        {
            try
            {
                property = property.CapitalizeFirstLetterWithSplitter(".");
                var type = Helper.GetPropertyType<T>(property);
                if (!Helper.TryConvert(value, type, out object _value))
                {
                    return False<T>();
                }
                // e
                ParameterExpression pe = Expression.Parameter(typeof(T), "e");
                // e.property
                Expression left = CreateExpression(pe, property);
                Expression right = Expression.Constant(_value, type);
                // e.property == value
                Expression expression = Expression.Equal(left, right);
                return Expression.Lambda<Func<T, bool>>(expression, pe);
            }
            catch (Exception)
            {
                return False<T>();
            }
        }

        public static Expression<Func<T, bool>> NotEqual<T>(string property, object value)
        {
            try
            {
                property = property.CapitalizeFirstLetterWithSplitter(".");
                var type = Helper.GetPropertyType<T>(property);
                if (!Helper.TryConvert(value, type, out object _value))
                {
                    return False<T>();
                }
                // e
                ParameterExpression pe = Expression.Parameter(typeof(T), "e");
                // e.property
                Expression left = CreateExpression(pe, property);
                Expression right = Expression.Constant(_value, type);
                // e.property != value
                Expression expression = Expression.NotEqual(left, right);
                return Expression.Lambda<Func<T, bool>>(expression, pe);
            }
            catch (Exception)
            {
                return False<T>();
            }
        }

        public static Expression<Func<T, bool>> Contains<T>(string property, string value)
        {
            try
            {
                property = property.CapitalizeFirstLetterWithSplitter(".");
                var type = typeof(string);
                if (!Helper.TryConvert(value, type, out object _value))
                {
                    return False<T>();
                }
                // e
                ParameterExpression pe = Expression.Parameter(typeof(T), "e");
                // e.property
                Expression left = CreateExpression(pe, property);
                Expression right = Expression.Constant(_value, type);
                MethodInfo method = typeof(string).GetMethod("Contains", new[] { typeof(string) });
                // e.property.contains(value)
                var containsExpression = Expression.Call(left, method, right);
                return Expression.Lambda<Func<T, bool>>(containsExpression, pe);
            }
            catch (Exception)
            {
                return False<T>();
            }
        }

        public static Expression<Func<T, bool>> ContainsList<T>(string property, string value)
        {
            try
            {
                property = property.CapitalizeFirstLetterWithSplitter(".");
                var type = Helper.GetPropertyType<T>(property);
                var listType = Helper.GetPropertyType<T>(property);
                if (!type.IsGenericType || type.GetGenericTypeDefinition() != typeof(List<>))
                {
                    return False<T>();
                }
                type = type.GetGenericArguments()[0];
                if (!Helper.TryConvert(value, type, out object _value))
                {
                    return False<T>();
                }

                // e
                ParameterExpression pe = Expression.Parameter(typeof(T), "e");
                // e.property
                Expression left = CreateExpression(pe, property);
                Expression right = Expression.Constant(_value, type);
                MethodInfo method = listType.GetMethod("Contains", new[] { type });
                // e.property.contains(value)
                var containsExpression = Expression.Call(left, method, right);
                return Expression.Lambda<Func<T, bool>>(containsExpression, pe);
            }
            catch (Exception)
            {
                return False<T>();
            }
        }

        public static Expression<Func<T, bool>> GreaterThanOrEqual<T>(string property, object value)
        {
            try
            {
                property = property.CapitalizeFirstLetterWithSplitter(".");
                var type = Helper.GetPropertyType<T>(property);
                if (!Helper.TryConvert(value, type, out object _value))
                {
                    return False<T>();
                }
                // e
                ParameterExpression pe = Expression.Parameter(typeof(T), "e");
                // e.property
                Expression left = CreateExpression(pe, property);
                // value
                Expression right = Expression.Constant(_value, type);
                // e.property >= value
                Expression expression = Expression.GreaterThanOrEqual(left, right);
                return Expression.Lambda<Func<T, bool>>(expression, pe);
            }
            catch (Exception)
            {
                return False<T>();
            }
        }

        public static Expression<Func<T, bool>> LessThanOrEqual<T>(string property, object value)
        {
            try
            {
                property = property.CapitalizeFirstLetterWithSplitter(".");
                var type = Helper.GetPropertyType<T>(property);
                if (!Helper.TryConvert(value, type, out object _value))
                {
                    return False<T>();
                }
                // e
                ParameterExpression pe = Expression.Parameter(typeof(T), "e");
                // e.property
                Expression left = CreateExpression(pe, property);
                Expression right = Expression.Constant(_value, type);
                MethodInfo method = type.GetMethod("CompareTo", new[] { type });
                // e.property.CompareTo(value)
                var containsExpression = Expression.Call(left, method, right);
                Expression zero = Expression.Constant(0, typeof(int));
                Expression expression = Expression.LessThanOrEqual(containsExpression, zero);
                return Expression.Lambda<Func<T, bool>>(expression, pe);
            }
            catch (Exception)
            {
                return False<T>();
            }
        }

        public static Expression<Func<T, object>> OrderBy<T>(string property)
        {
            property = property.CapitalizeFirstLetterWithSplitter(".");
            var type = Helper.GetPropertyType<T>(property);
            // e
            ParameterExpression pe = Expression.Parameter(typeof(T), "e");
            // e.property
            Expression left = CreateExpression(pe, property);
            Expression conversion = Expression.Convert(left, typeof(object));
            return Expression.Lambda<Func<T, object>>(conversion, pe);
        }
    }

    public static class PredicateBuilder2
    {
        public enum SearchType
        {
            IsIn,
            NotEqual,
            Equal,
            Less,
            LessOrEqual,
            Greater,
            GreaterOrEqual,
            BeginsWith,
            DoesNotBeginWith,
            IsNotIn,
            EndsWith,
            DoesNotEndWith,
            Contains,
            DoesNotContain,
            IsNull,
            IsNotNull
        }

        /// <summary>
        ///  This is main Method of this Class It returns predicate
        ///  
        /// </summary>
        /// <typeparam name="T">Entity Type - Search Where</typeparam>
        /// <param name="modelPropertyName">property to compare (compare what)(can be nested property)</param>
        /// <param name="searchType">comparation Type (compare how)</param>
        /// <param name="data">data to compare (compare to what )</param>
        /// <returns>Able to translate to SQl predicate</returns>
        public static Expression<Func<T, bool>> GetPredicate<T>(String modelPropertyName, SearchType searchType, object data)
        {
            ParameterExpression parameterExp = Expression.Parameter(typeof(T), "t");
            MemberExpression member = Expression.PropertyOrField(parameterExp, modelPropertyName.Split('.').First());
            // If there are any dots in parram then we have to change expression 
            foreach (var innerMember in modelPropertyName.Split('.').Skip(1))
            {
                member = Expression.PropertyOrField(member, innerMember);
            }
            if (member.Type.BaseType.ToString() == "System.Enum")
            {
                data = Int32.Parse(data.ToString());
                String name = Enum.GetName(member.Type, data);
                data = Enum.Parse(member.Type, name, false);
            }
            else if (searchType != SearchType.IsIn)
            {
                switch (member.Type.ToString())
                {
                    case "System.Nullable`1[System.Decimal]":
                        data = data.ToString().ToNullableDecimal();
                        break;
                    case "System.Nullable`1[System.Double]":
                        data = data.ToString().ToNullableDouble();
                        break;
                    case "System.Nullable`1[System.Float]":
                        data = data.ToString().ToNullableFloat();
                        break;
                    case "System.Nullable`1[System.DateTime]":
                        data = data.ToString().ToNullableDateTime();
                        break;
                    case "System.Nullable`1[System.Int16]":
                        data = data.ToString().ToNullableInt16();
                        break;
                    case "System.Nullable`1[System.Int32]":
                        data = data.ToString().ToNullableInt32();
                        break;
                    case "System.Nullable`1[System.Int64]":
                        data = data.ToString().ToNullableInt64();
                        break;
                    case "System.Nullable`1[System.UInt16]":
                        data = data.ToString().ToNullableUInt16();
                        break;
                    case "System.Nullable`1[System.UInt32]":
                        data = data.ToString().ToNullableUInt32();
                        break;
                    case "System.Nullable`1[System.UInt64]":
                        data = data.ToString().ToNullableUInt64();
                        break;
                    case "System.Nullable`1[System.Boolean]":
                        data = data.ToString().ToNullableBoolean();
                        break;
                    case "System.Decimal":
                        data = decimal.Parse(data.ToString());
                        break;
                    case "System.Double":
                        data = double.Parse(data.ToString());
                        break;
                    case "System.Float":
                        data = float.Parse(data.ToString());
                        break;
                    case "System.DateTime":
                        data = DateTime.Parse(data.ToString());
                        break;
                    case "System.Int16":
                        data = Int16.Parse(data.ToString());
                        break;
                    case "System.Int32":
                        data = Int32.Parse(data.ToString());
                        break;
                    case "System.Int64":
                        data = Int64.Parse(data.ToString());
                        break;
                    case "System.UInt16":
                        data = UInt16.Parse(data.ToString());
                        break;
                    case "System.UInt32":
                        data = UInt32.Parse(data.ToString());
                        break;
                    case "System.UInt64":
                        data = UInt64.Parse(data.ToString());
                        break;
                    case "System.Byte":
                        data = Byte.Parse(data.ToString());
                        break;
                    case "System.Boolean":
                        data = Boolean.Parse(data.ToString());
                        break;
                }
            }
            ConstantExpression valuetoCheck;
            if (searchType == SearchType.IsIn)
            {
                valuetoCheck = Expression.Constant(data, member.Type);
            }
            else
            {
                valuetoCheck = Expression.Constant(data, member.Type);
            }
            Expression expression = getExpression<T>(searchType, member, valuetoCheck);
            Expression<Func<T, bool>> predicate = Expression.Lambda<Func<T, bool>>(expression, new ParameterExpression[] { parameterExp });
            return predicate;
        }
        private static Expression getExpression<T>(SearchType searchType, MemberExpression member, ConstantExpression valuetoCheck)
        {
            Expression expression;
            switch (searchType)
            {
                case SearchType.Equal:
                    expression = Equals<T>(member, valuetoCheck);
                    break;
                case SearchType.NotEqual:
                    expression = NotEquals<T>(member, valuetoCheck);
                    break;
                case SearchType.Less:
                    expression = Less<T>(member, valuetoCheck);
                    break;
                case SearchType.LessOrEqual:
                    expression = LessOrEqual<T>(member, valuetoCheck);
                    break;
                case SearchType.Greater:
                    expression = More<T>(member, valuetoCheck);
                    break;
                case SearchType.GreaterOrEqual:
                    expression = MoreorEqual<T>(member, valuetoCheck);
                    break;
                case SearchType.BeginsWith:
                    expression = BeginsWith<T>(member, valuetoCheck);
                    break;
                case SearchType.DoesNotBeginWith:
                    expression = NotBeginsWith<T>(member, valuetoCheck);
                    break;
                case SearchType.IsIn:
                    expression = IsIn<T>(member, valuetoCheck);
                    break;
                case SearchType.IsNotIn:
                    expression = NotContains<T>(member, valuetoCheck);
                    break;
                case SearchType.EndsWith:
                    expression = EndsWith<T>(member, valuetoCheck);
                    break;
                case SearchType.DoesNotEndWith:
                    expression = NotEndsWith<T>(member, valuetoCheck);
                    break;
                case SearchType.Contains:
                    expression = Contains<T>(member, valuetoCheck);
                    break;
                case SearchType.DoesNotContain:
                    expression = NotContains<T>(member, valuetoCheck);
                    break;
                case SearchType.IsNull:
                    expression = IsNull<T>(member, valuetoCheck);
                    break;
                case SearchType.IsNotNull:
                    expression = IsNotNull<T>(member, valuetoCheck);
                    break;
                default:
                    expression = Expression<Func<T, bool>>.Equal(member, valuetoCheck);
                    break;
            }
            return expression;
        }
        public static Expression<Func<T, bool>> And<T>(this Expression<Func<T, bool>> expr1,
                                                             Expression<Func<T, bool>> expr2)
        {
            var invokedExpr = Expression.Invoke(expr2, expr1.Parameters.Cast<Expression>());
            return Expression.Lambda<Func<T, bool>>
                  (Expression.AndAlso(expr1.Body, invokedExpr), expr1.Parameters);
        }
        public static Expression<Func<T, bool>> Or<T>(this Expression<Func<T, bool>> expr1,
                                                            Expression<Func<T, bool>> expr2)
        {
            var invokedExpr = Expression.Invoke(expr2, expr1.Parameters.Cast<Expression>());
            return Expression.Lambda<Func<T, bool>>
                  (Expression.OrElse(expr1.Body, invokedExpr), expr1.Parameters);
        }
        public static Expression<Func<T, bool>> False<T>()
        {
            return f => false;
        }
        public static Expression<Func<T, bool>> True<T>()
        {
            return f => true;
        }
        public static IList CreateList(Type type)
        {
            Type genericListType = typeof(List<>).MakeGenericType(type);
            return ((IList)Activator.CreateInstance(genericListType));
        }
        public static Type GetListType(Type type)
        {
            return CreateList(type).GetType();
        }
        private static Expression BeginsWith<T>(MemberExpression member, ConstantExpression valuetoCheck)
        {
            MethodInfo method = typeof(string).GetMethod("StartsWith", new[] { typeof(string) });
            return Expression<Func<T, bool>>.Call(member, method, valuetoCheck);
        }
        private static Expression Contains<T>(MemberExpression member, ConstantExpression valuetoCheck)
        {
            MethodInfo method = typeof(string).GetMethod("Contains", new[] { typeof(string) });
            return Expression<Func<T, bool>>.Call(member, method, valuetoCheck);
        }
        private static Expression IsIn<T>(MemberExpression member, ConstantExpression valuetoCheck)
        {
            MethodInfo method = GetListType(member.Type).GetMethod("Contains", new[] { member.Type });
            return Expression<Func<T, bool>>.Call(valuetoCheck, method, member);
        }
        private static Expression EndsWith<T>(MemberExpression member, ConstantExpression valuetoCheck)
        {
            MethodInfo method = typeof(string).GetMethod("EndsWith", new[] { typeof(string) });
            return Expression<Func<T, bool>>.Call(member, method, valuetoCheck);
        }
        private static Expression Equals<T>(MemberExpression member, ConstantExpression valuetoCheck)
        {
            return Expression<Func<T, bool>>.Equal(member, valuetoCheck);
        }
        private static Expression IsNotNull<T>(MemberExpression member, ConstantExpression valuetoCheck)
        {
            return Expression<Func<T, bool>>.NotEqual(member, Expression.Constant(null, member.Type));
        }
        private static Expression IsNull<T>(MemberExpression member, ConstantExpression valuetoCheck)
        {
            return Expression<Func<T, bool>>.Equal(member, Expression.Constant(null, member.Type));
        }
        private static Expression Less<T>(MemberExpression member, ConstantExpression valuetoCheck)
        {
            return Expression<Func<T, bool>>.LessThan(member, valuetoCheck);
        }
        private static Expression LessOrEqual<T>(MemberExpression member, ConstantExpression valuetoCheck)
        {
            return Expression<Func<T, bool>>.LessThanOrEqual(member, valuetoCheck);
        }
        private static Expression More<T>(MemberExpression member, ConstantExpression valuetoCheck)
        {
            return Expression<Func<T, bool>>.GreaterThan(member, valuetoCheck);
        }
        private static Expression MoreorEqual<T>(MemberExpression member, ConstantExpression valuetoCheck)
        {
            return Expression<Func<T, bool>>.GreaterThanOrEqual(member, valuetoCheck);
        }
        private static Expression NotBeginsWith<T>(MemberExpression member, ConstantExpression valuetoCheck)
        {
            MethodInfo method = typeof(string).GetMethod("StartsWith", new[] { typeof(string) });
            return Expression.Not(Expression<Func<T, bool>>.Call(member, method, valuetoCheck));
        }
        private static Expression NotContains<T>(MemberExpression member, ConstantExpression valuetoCheck)
        {
            MethodInfo method = typeof(string).GetMethod("Contains", new[] { typeof(string) });
            return Expression.Not(Expression<Func<T, bool>>.Call(member, method, valuetoCheck));
        }
        private static Expression NotEndsWith<T>(MemberExpression member, ConstantExpression valuetoCheck)
        {
            MethodInfo method = typeof(string).GetMethod("EndsWith", new[] { typeof(string) });
            return Expression.Not(Expression<Func<T, bool>>.Call(member, method, valuetoCheck));
        }
        private static Expression NotEquals<T>(MemberExpression member, ConstantExpression valuetoCheck)
        {
            return Expression<Func<T, bool>>.NotEqual(member, valuetoCheck);
        }

        private static UInt64? ToNullableUInt64(this string s)
        {
            UInt64 i;
            if (UInt64.TryParse(s, out i)) return i;
            return null;
        }
        private static UInt32? ToNullableUInt32(this string s)
        {
            UInt32 i;
            if (UInt32.TryParse(s, out i)) return i;
            return null;
        }
        private static UInt16? ToNullableUInt16(this string s)
        {
            UInt16 i;
            if (UInt16.TryParse(s, out i)) return i;
            return null;
        }
        private static Int64? ToNullableInt64(this string s)
        {
            Int64 i;
            if (Int64.TryParse(s, out i)) return i;
            return null;
        }
        private static Int32? ToNullableInt32(this string s)
        {
            Int32 i;
            if (Int32.TryParse(s, out i)) return i;
            return null;
        }
        private static Int16? ToNullableInt16(this string s)
        {
            Int16 i;
            if (Int16.TryParse(s, out i)) return i;
            return null;
        }
        private static float? ToNullableFloat(this string s)
        {
            float i;
            if (float.TryParse(s, out i)) return i;
            return null;
        }
        private static double? ToNullableDouble(this string s)
        {
            double i;
            if (double.TryParse(s, out i)) return i;
            return null;
        }
        private static Decimal? ToNullableDecimal(this string s)
        {
            decimal i;
            if (Decimal.TryParse(s, out i)) return i;
            return null;
        }
        private static Boolean? ToNullableBoolean(this string s)
        {
            bool i;
            if (Boolean.TryParse(s, out i)) return i;
            return null;
        }
        private static DateTime? ToNullableDateTime(this string s)
        {
            DateTime i;
            if (DateTime.TryParse(s, out i)) return i;
            return null;
        }
    }
}
