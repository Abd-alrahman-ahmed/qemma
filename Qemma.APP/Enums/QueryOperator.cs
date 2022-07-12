namespace Qemma.APP.Enums
{
    public enum QueryOperator
    {
        [Description("Equal")]
        eq,
        [Description("NotEqual")]
        neq,
        [Description("Contains")]
        contains,
        [Description("Contains_Array")]
        array_contains,
        [Description("GreaterThan")]
        gt,
        [Description("GreaterThanOrEqual")]
        ge,
        [Description("LessThan")]
        lt,
        [Description("LessThanOrEqual")]
        le,
    }
}
