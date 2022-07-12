namespace Qemma.APP.Helper
{
    public static class ChartAggregationHelper
    {
        public static DateTime GetDateKey(DateTime date, ChartOperator chartOperator)
        {
            switch (chartOperator)
            {
                case ChartOperator.daily:
                    return new DateTime(date.Year, date.Month, date.Day);
                case ChartOperator.monthy:
                    return new DateTime(date.Year, date.Month, 1);
                default:
                    return date;
            }
        }
    }
}
