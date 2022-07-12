namespace Qemma.APP.Helper
{
    public class PageResult<T>
    {
        public int Count { get; set; }
        public int PageNo { get; set; }
        public int PageSize { get; set; }
        public IEnumerable<T> Data { get; set; }
    }
}
