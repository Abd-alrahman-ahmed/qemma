namespace Qemma.APP.Extensions
{
    public static class DateTimeExtensions
    {
        public static DateTime SetTime(this DateTime dateTime, TimeSpan time)
        {
            dateTime = dateTime.Date + time;
            return dateTime;
        }

        public static DateTime StartOfDay(this DateTime dateTime)
        {
            return dateTime.Date;
        }

        public static DateTime EndOfDay(this DateTime dateTime)
        {
            var result = new DateTime(dateTime.Ticks);
            return result.SetTime(new TimeSpan(23, 59, 59));
        }

        public static DateTime StartOfWeek(this DateTime dateTime, DayOfWeek startOfWeek)
        {
            int diff = (7 + (dateTime.DayOfWeek - startOfWeek)) % 7;
            return dateTime.AddDays(-1 * diff).Date;
        }

        public static DateTime StartOfMonth(this DateTime datetime)
        {
            return datetime.Date.AddDays(1 - datetime.Day);
        }

        public static DayOfWeek DayOfWeek(this DayOfWeek day, DayOfWeek startOfWeek)
        {
            int restOfDays = 7 - (int)startOfWeek;
            int currentDay = ((int)day + restOfDays) % 7;
            return (DayOfWeek)Enum.ToObject(typeof(DayOfWeek), currentDay);
        }

        public static DateTime Max(params DateTime[] dates)
        {
            return dates.Aggregate((a, b) => a > b ? a : b);
        }

        public static DateTime Min(params DateTime[] dates)
        {
            return dates.Aggregate((a, b) => a < b ? a : b);
        }
    }
}
