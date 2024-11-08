//-----------------------------------------------------------------------
// <copyright file="Extensions.cs" company="Luppes Consulting, Inc.">
// Copyright 2024, Luppes Consulting, Inc. All rights reserved.
// </copyright>
// <summary>
// Extensions
// </summary>
//-----------------------------------------------------------------------
namespace DadABase.Helpers;

/// <summary>
/// Generic Extensions
/// </summary>
[ExcludeFromCodeCoverage]
public static class Extensions
{
    /// <summary>
    /// Converts object to string but doesn't crash if it's null
    /// </summary>
    public static string ToStringNullable(this object obj)
    {
        return (obj ?? "").ToString();
    }
    /// <summary>
    /// Converts object to string but doesn't crash if it's null
    /// </summary>
    public static string ToStringNullable(this object obj, string defaultValue)
    {
        return (obj ?? defaultValue).ToString();
    }
}
