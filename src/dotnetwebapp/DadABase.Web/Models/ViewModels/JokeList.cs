//-----------------------------------------------------------------------
// <copyright file="JokeList.cs" company="Luppes Consulting, Inc.">
// Copyright 2024, Luppes Consulting, Inc. All rights reserved.
// </copyright>
// <summary>
// List of Jokes
// </summary>
//-----------------------------------------------------------------------
namespace DadABase.Data;

/// <summary>
/// List of Jokes
/// </summary>
[ExcludeFromCodeCoverage]
public class JokeList
{
    /// <summary>
    /// Jokes
    /// </summary>
    public List<Joke> Jokes { get; set; }

    /// <summary>
    /// Constructor
    /// </summary>
    public JokeList()
    {
        Jokes = [];
    }
}
