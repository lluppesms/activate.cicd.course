//-----------------------------------------------------------------------
// <copyright file="_BaseRepository.cs" company="Luppes Consulting, Inc.">
// Copyright 2024, Luppes Consulting, Inc. All rights reserved.
// </copyright>
// <summary>
// Base Repository
// </summary>
//-----------------------------------------------------------------------
namespace DadABase.Data;

/// <summary>
/// Base Repository
/// </summary>
[ExcludeFromCodeCoverage]
public class BaseRepository
{
    #region Variables

    /// <summary>
    /// Database Entities
    /// </summary>
    public ProjectEntities DB;

    /// <summary>
    /// Application Settings
    /// </summary>
    protected AppSettings AppSettingsValues;
    #endregion

    #region Configuration Functions
    /// <summary>
    /// reads the web.config file
    /// </summary>
    /// <param name="settingName">Setting Name</param>
    /// <returns>Value</returns>
    public string GetConnectionStringValue(string settingName)
    {
        try
        {
            //if (System.Configuration.ConfigurationManager.ConnectionStrings[settingName] != null)
            //{
            //    return System.Configuration.ConfigurationManager.ConnectionStrings[settingName].ToString();
            //}

            if (AppSettingsValues != null)
            {
                return settingName.ToLower() switch
                {
                    "projectentities" => AppSettingsValues.ProjectEntities,
                    _ => AppSettingsValues.DefaultConnection,
                };
            }
            return string.Empty;
        }
        catch
        {
            return string.Empty;
        }
    }
    #endregion

    #region Logging Functions

    /// <summary>
    /// Write value to log.
    /// </summary>
    /// <param name="msg">Message Text.</param>
    public static void WriteToLog(string msg)
    {
        System.Diagnostics.Trace.TraceInformation(msg);
        ////var logDirectory = GetConfigKeyValue("LogDirectory");
        ////var logFileName = GetConfigKeyValue("LogFileName");

        ////StreamWriter myStreamWriter = null;
        ////try
        ////{
        ////  if (logDirectory.Length <= 0)
        ////  {
        ////    logDirectory = @"C:\Logs\";
        ////  }

        ////  if (logFileName.Length <= 0)
        ////  {
        ////    logFileName = "TimeCrunchWeb.log";
        ////  }

        ////  logFileName = DateifyFileName(logDirectory + logFileName);
        ////  if (!Directory.Exists(logDirectory))
        ////  {
        ////    Directory.CreateDirectory(logDirectory);
        ////  }

        ////  if (logFileName == string.Empty)
        ////  {
        ////    return;
        ////  }
        ////  myStreamWriter = File.AppendText(logFileName);
        ////  myStreamWriter.WriteLine("{0}\t{1}", DateTime.Now, msg);
        ////  myStreamWriter.Flush();
        ////}
        ////catch
        ////{
        ////  ////  do nothing with the message ?
        ////}
        ////finally
        ////{
        ////  //// Close the object if it has been created.
        ////  if (myStreamWriter != null)
        ////  {
        ////    myStreamWriter.Close();
        ////  }
        ////}
    }

    /// <summary>
    /// Write value to log.
    /// </summary>
    /// <param name="msg">Message Text.</param>
    public static void WriteSevereError(string msg)
    {
        WriteSevereError(string.Empty, msg, string.Empty, string.Empty);
    }

    /// <summary>
    /// Write value to log.
    /// </summary>
    /// <param name="msg">Message Text.</param>
    /// <param name="url">URL for the page with an error.</param>
    /// <param name="userName">User Name.</param>
    public static void WriteSevereError(string msg, string url, string userName)
    {
        WriteSevereError(string.Empty, msg, url, userName);
    }

    /// <summary>
    /// Write value to log.
    /// </summary>
    /// <param name="subjectText">Subject of email.</param>
    /// <param name="msg">Message Text.</param>
    /// <param name="url">URL for the page with an error.</param>
    /// <param name="userName">User Name.</param>
#pragma warning disable IDE0060 // Remove unused parameter
    public static void WriteSevereError(string subjectText, string msg, string url, string userName)
#pragma warning restore IDE0060 // Remove unused parameter
    {
        System.Diagnostics.Trace.TraceError(msg);
        ////////var returnMessageText = string.Empty;
        ////msg = msg.Trim();
        ////if (msg.StartsWith("Thread was being aborted") || msg.EndsWith("Thread was being aborted") ||
        ////    msg.EndsWith("Thread was being aborted."))
        ////{
        ////  return;
        ////}

        ////// always write to database
        ////try
        ////{
        ////  var logEntry = new ErrorLog
        ////  {
        ////    ErrorMessage = msg,
        ////    CreateDateTime = DateTime.Now,
        ////    CreateUserId = userName
        ////  };
        ////  DB.ErrorLog.Add(logEntry);
        ////  DB.SaveChanges();
        ////}
        ////catch
        ////{
        ////  //  do nothing with the message ?
        ////}

        ////if (url == string.Empty)
        ////{
        ////  url = "Unknown";
        ////}
        //////// write to local text file if on local machine
        ////if (url.IndexOf("localhost", StringComparison.CurrentCultureIgnoreCase) > 0)
        ////{
        ////  WriteToLog(msg);
        ////}
        ////else
        ////{
        ////try
        ////{
        //////// send email to admins if it's not local machine
        ////string errorEmail = GetConfigKeyValue("EmailSendTo");
        ////string siteName = GetConfigKeyValue("ApplicationName");
        ////if (siteName == string.Empty)
        ////{
        ////  siteName = "website";
        ////}
        ////if (subjectText == string.Empty)
        ////{
        ////  subjectText = "An error occured in " + siteName + "!";
        ////}
        ////else
        ////{
        ////  subjectText = subjectText.Replace("@SiteName", siteName);
        ////}
        ////var msgPlus = msg + "<br /><br />" + "\n" +
        ////  "Sent from " + url + "<br />" + "\n" +
        ////  "User: " + userName + "<br />" + "\n" +
        ////  "Machine " + Environment.MachineName + "<br />" + "\n";
        ////SendMail(errorEmail, "HTML", subjectText, msgPlus, ref returnMessageText);
        ////}
        ////catch
        ////{
        ////  ////  do nothing with the message ?
        ////}
        ////}
    }

    /// <summary>
    /// Convert file name to format that contains date as numbers.
    /// </summary>
    /// <param name="parmFileName">File Name to be changed.</param>
    /// <returns>File Name.</returns>
    public static string DateifyFileName(string parmFileName)
    {
        var newDate = DateTime.Today.ToString("yyyyMMdd");
        var period = parmFileName.IndexOf(".", StringComparison.Ordinal);
        if (period > 0)
        {
            parmFileName = parmFileName[..period] + newDate + parmFileName[period..];
        }
        else
        {
            parmFileName += newDate;
        }

        return parmFileName;
    }

    /// <summary>
    /// Gets inner exception message.
    /// </summary>
    /// <param name="ex">The Exception.</param>
    /// <returns>The Full Message.</returns>
    public static string GetExceptionMessage(Exception ex)
    {
        var message = string.Empty;
        if (ex == null)
        {
            return message;
        }

        if (ex.Message != null)
        {
            ////if (ex.GetType().IsAssignableFrom(typeof(DbEntityValidationException)))
            ////{
            ////    var exv = (DbEntityValidationException)ex;
            ////    foreach (var eve in exv.EntityValidationErrors)
            ////    {
            ////        foreach (var ve in eve.ValidationErrors)
            ////        {
            ////            message += " " + ve.PropertyName + ": " + ve.ErrorMessage;
            ////        }
            ////    }
            ////}
            ////else
            ////{
            message += ex.Message;
            ////}
        }

        if (ex.InnerException == null)
        {
            return message;
        }

        if (ex.InnerException.Message != null)
        {
            message += " " + ex.InnerException.Message;
        }

        if (ex.InnerException.InnerException == null)
        {
            return message;
        }

        if (ex.InnerException.InnerException.Message != null)
        {
            message += " " + ex.InnerException.InnerException.Message;
        }

        if (ex.InnerException.InnerException.InnerException == null)
        {
            return message;
        }

        if (ex.InnerException.InnerException.InnerException.Message != null)
        {
            message += " " + ex.InnerException.InnerException.InnerException.Message;
        }

        return message;
    }

    #endregion

    #region Nullable Object Helpers

    /// <summary>
    /// Returns a string.
    /// </summary>
    /// <param name="o">Input parameter.</param>
    /// <returns>Return value.</returns>
    public static string CStrNull(object o)
    {
        return CStrNull(o, string.Empty);
    }

    /// <summary>
    /// Returns a string.
    /// </summary>
    /// <param name="o">Input parameter.</param>
    /// <param name="dflt">Default value.</param>
    /// <returns>Return value.</returns>
    public static string CStrNull(object o, string dflt)
    {
        string returnValue;
        try
        {
            if (o != null && !Convert.IsDBNull(o))
            {
                returnValue = o.ToString();
            }
            else
            {
                returnValue = dflt;
            }
        }
        catch
        {
            returnValue = null;
        }

        return returnValue;
    }

    /// <summary>
    /// Returns a decimal.
    /// </summary>
    /// <param name="o">Input parameter.</param>
    /// <returns>Return value.</returns>
    public static decimal CDecNull(object o)
    {
        return CDecNull(o, 0);
    }

    /// <summary>
    /// Returns a decimal.
    /// </summary>
    /// <param name="o">Input parameter.</param>
    /// <param name="dflt">Default value.</param>
    /// <returns>Return value.</returns>
    public static decimal CDecNull(object o, decimal dflt)
    {
        decimal returnValue;
        try
        {
            if (o != null && !Convert.IsDBNull(o))
            {
                returnValue = Convert.ToDecimal(o);
            }
            else
            {
                returnValue = dflt;
            }
        }
        catch
        {
            return decimal.MinValue;
        }

        return returnValue;
    }

    /// <summary>
    /// Returns an integer.
    /// </summary>
    /// <param name="o">Input parameter.</param>
    /// <returns>Return value.</returns>
    public static int CIntNull(object o)
    {
        return CIntNull(o, 0);
    }

    /// <summary>
    /// Returns an integer.
    /// </summary>
    /// <param name="o">Input parameter.</param>
    /// <param name="dflt">Default value.</param>
    /// <returns>Return value.</returns>
    public static int CIntNull(object o, int dflt)
    {
        int returnValue;
        try
        {
            if (o != null && !Convert.IsDBNull(o) && Convert.ToString(o) != string.Empty)
            {
                returnValue = Convert.ToInt32(o);
            }
            else
            {
                returnValue = dflt;
            }
        }
        catch
        {
            return int.MinValue;
        }

        return returnValue;
    }

    /// <summary>
    /// Returns a DateTime object.
    /// </summary>
    /// <param name="o">Input parameter.</param>
    /// <returns>Return value.</returns>
    public static DateTime CDateNull(object o)
    {
        return CDateNull(o, DateTime.MinValue);
    }

    /// <summary>
    /// Returns a DateTime object.
    /// </summary>
    /// <param name="o">Input parameter.</param>
    /// <param name="dflt">Default value.</param>
    /// <returns>Return value.</returns>
    public static DateTime CDateNull(object o, DateTime dflt)
    {
        DateTime returnValue;
        try
        {
            if (o != null && !Convert.IsDBNull(o))
            {
                returnValue = Convert.ToDateTime(o);
            }
            else
            {
                returnValue = dflt;
            }
        }
        catch
        {
            return DateTime.MinValue;
        }

        return returnValue;
    }

    /// <summary>
    /// Returns an Guid.
    /// </summary>
    /// <param name="o">Input parameter.</param>
    /// <returns>Return value.</returns>
    public static Guid CGuidNull(object o)
    {
        Guid returnValue;
        try
        {
            if (o != null && !Convert.IsDBNull(o) && Convert.ToString(o) != string.Empty)
            {
                returnValue = (Guid)o;
            }
            else
            {
                returnValue = Guid.Empty;
            }
        }
        catch
        {
            return Guid.Empty;
        }

        return returnValue;
    }
    #endregion
}