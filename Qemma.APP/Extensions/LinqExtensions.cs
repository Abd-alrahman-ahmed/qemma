using System.Text.RegularExpressions;

namespace Qemma.APP.Extensions
{
    public static class LinqExtensions
    {
        public static Query CreateQueryFilter(this Query source, string filter)
        {
            Query result = source;
            filter ??= "";
            var pattern = new Regex(";f--(and|or)--f;");
            var queries = pattern.Split(filter);

            for (int i = 0; i < queries.Length; i++)
            {
                var query = queries[i];
                var _filterParts = query.Split(" ", 3);
                if (_filterParts.Length != 3) continue;
                var field = _filterParts[0];
                var op = _filterParts[1];
                var value = _filterParts[2];
                if (op == null || !Enum.IsDefined(typeof(QueryOperator), op)) continue;

                var operatorEnum = Enum.Parse<QueryOperator>(op, ignoreCase: true);
                switch (operatorEnum)
                {
                    case QueryOperator.eq:
                        result = result.WhereEqualTo(field, value);
                        break;
                    case QueryOperator.neq:
                        result = result.WhereNotEqualTo(field, value);
                        break;
                    case QueryOperator.ge:
                        result = result.WhereGreaterThanOrEqualTo(field, value);
                        break;
                    case QueryOperator.le:
                        result = result.WhereLessThanOrEqualTo(field, value);
                        break;
                    default:
                        continue;
                }
            }

            return result;
        }

        public static Query ToPage(this Query source, int pageNo, int pageSize)
        {
            if (pageSize <= 0) return source;

            pageNo = Math.Max(1, pageNo);
            return source.Offset((pageNo - 1) * pageSize).Limit(pageSize);
        }

        public static Query Order(this Query source, string orderDir = "ASC", string orderBy = "")
        {
            if (string.IsNullOrWhiteSpace(orderBy)) return source;

            if (orderDir == "DESC")
                return source.OrderByDescending(orderBy);
            return source.Order(orderBy);
        }

        public static IEnumerable<TSource> DistinctBy<TSource, TKey>(this IEnumerable<TSource> source, Func<TSource, TKey> keySelector)
        {
            HashSet<TKey> seenKeys = new();
            foreach (TSource element in source)
            {
                if (seenKeys.Add(keySelector(element)))
                {
                    yield return element;
                }
            }
        }

        public static IEnumerable<TEntity> Order<TEntity>(this IEnumerable<TEntity> source, string orderDir = null, string orderBy = null)
        {
            if (string.IsNullOrWhiteSpace(orderBy)) return source;

            var orderByExpression = PredicateBuilder.OrderBy<TEntity>(orderBy).Compile();
            if (orderDir == "DESC")
                return source.OrderByDescending(orderByExpression);
            return source.OrderBy(orderByExpression);
        }

        public static IEnumerable<TEntity> CreateFilterExpression<TEntity>(this IEnumerable<TEntity> source, string filter)
        {
            var result = PredicateBuilder.True<TEntity>();
            filter ??= "";
            var pattern = new Regex(";f--(and|or)--f;");
            var queries = pattern.Split(filter);
            var logicalOperatorMatch = pattern.Match(filter);
            var isOr = true;
            if (logicalOperatorMatch.Success)
            {
                isOr = logicalOperatorMatch.Value.Contains("or");
            }
            for (int i = 0; i < queries.Length; i++)
            {
                var query = queries[i];
                var _filterParts = query.Split(" ", 3);
                if (_filterParts.Length != 3) continue;
                var field = _filterParts[0];
                var op = _filterParts[1];
                var value = _filterParts[2];
                if (op == null || !Enum.IsDefined(typeof(QueryOperator), op)) continue;

                var operatorEnum = Enum.Parse<QueryOperator>(op, ignoreCase: true);
                Expression<Func<TEntity, bool>> _expression;
                switch (operatorEnum)
                {
                    case QueryOperator.eq:
                        _expression = PredicateBuilder.Equal<TEntity>(field, value);
                        break;
                    case QueryOperator.neq:
                        _expression = PredicateBuilder.NotEqual<TEntity>(field, value);
                        break;
                    case QueryOperator.contains:
                        _expression = PredicateBuilder.Contains<TEntity>(field, value);
                        break;
                    case QueryOperator.array_contains:
                        _expression = PredicateBuilder.ContainsList<TEntity>(field, value);
                        break;
                    case QueryOperator.ge:
                        _expression = PredicateBuilder2.GetPredicate<TEntity>(field, PredicateBuilder2.SearchType.GreaterOrEqual, value);
                        break;
                    case QueryOperator.le:
                        _expression = PredicateBuilder.LessThanOrEqual<TEntity>(field, value);
                        break;
                    default:
                        continue;
                }
                if (i == 0)
                {
                    result = _expression;
                }
                else
                {
                    result = isOr ? PredicateBuilder.Or(result, _expression) : PredicateBuilder.And(result, _expression);
                }
            }

            return source.Where(result.Compile());
        }

        public static PageResult<TSource> ToPage<TSource>(this IEnumerable<TSource> source, int pageNo, int pageSize)
        {
            var result = new PageResult<TSource>
            {
                Count = source.Count(),
                PageNo = pageNo,
                PageSize = pageSize,
                Data = source
            };

            if (pageSize <= 0)
            {
                result.Data = result.Data.ToList();
                return result;
            }

            pageNo = Math.Max(1, pageNo);
            result.Data = source.Skip((pageNo - 1) * pageSize).Take(pageSize).ToList();
            return result;
        }

        public static IEnumerable<T> Set<T>(this IEnumerable<T> self, Action<T> action)
        {
            foreach (var item in self)
            {
                action(item);
                yield return item;
            }
        }
    }
}
