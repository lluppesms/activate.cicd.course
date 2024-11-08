//-----------------------------------------------------------------------
// <copyright file="_BaseController.cs" company="Luppes Consulting, Inc.">
// Copyright 2024, Luppes Consulting, Inc. All rights reserved.
// </copyright>
// <summary>
// Base Controller
// </summary>
//-----------------------------------------------------------------------
namespace DadABase.API;

/// <summary>
/// Base Controller
/// </summary>
[ExcludeFromCodeCoverage]
public class BaseAPIController : ControllerBase
{
    #region Initialization
    /// <summary>
    /// Access Application Settings
    /// </summary>
    protected AppSettings AppSettingsValues;

    /// <summary>
    /// Access the HTTPContext for this request
    /// </summary>
    protected IHttpContextAccessor context;

    /// <summary>
    /// Access the HTTPContext for this request
    /// </summary>
    protected ProjectEntities database;

    /// <summary>
    /// AutoMapper Object
    /// </summary>
#pragma warning disable CA2211 // Non-constant fields should not be visible
    protected static IMapper iMapper = null;
#pragma warning restore CA2211 // Non-constant fields should not be visible

    /// <summary>
    /// Base Controller Instantiation
    /// </summary>1
    public BaseAPIController()
    {
    }
    #endregion

    #region AutoMapper
    /// <summary>
    /// Set up Auto Mapper
    /// </summary>
    protected static void SetupAutoMapper()
    {
        if (iMapper == null)
        {
            var mapperConfig = new MapperConfiguration(cfg =>
            {
                cfg.CreateMap<Joke, JokeBasic>()
                    .ForMember(dest => dest.Joke, opt => opt.MapFrom(src => src.JokeTxt))
                    .ForMember(dest => dest.Category, opt => opt.MapFrom(src => src.JokeCategoryTxt));
                cfg.CreateMap<JokeCategory, CategoryBasic>()
                    .ForMember(dest => dest.Category, opt => opt.MapFrom(src => src.JokeCategoryTxt));
            });
            mapperConfig.AssertConfigurationIsValid();
            iMapper = mapperConfig.CreateMapper();
        }
    }
#endregion

    #region Auth Helpers
    /// <summary>
    /// Returns User Name if logged on, UNKNOWN if not
    /// </summary>
    /// <returns>User Name</returns>
    protected string GetUserName()
    {
        var currentName = context != null && context.HttpContext != null && context.HttpContext.User != null && context.HttpContext.User.Identity != null && context.HttpContext.User.Identity.Name != null ? context.HttpContext.User.Identity.Name : "UNKNOWN";
        if (currentName == "UNKNOWN")
        {
            currentName = "BOGUS"; //  "lyle@luppes.com";
        }
        var domainIndicator = currentName.IndexOf("#");
        if (domainIndicator > 0)
        {
            currentName = currentName.Substring(domainIndicator + 1, currentName.Length - domainIndicator - 1);
        }
        if ((currentName.StartsWith("lyleluppes", StringComparison.CurrentCultureIgnoreCase) || currentName.StartsWith("lyle.luppes", StringComparison.CurrentCultureIgnoreCase) || currentName.StartsWith("lyle@lyleluppes", StringComparison.CurrentCultureIgnoreCase))
         && (currentName.EndsWith("gmail.com", StringComparison.CurrentCultureIgnoreCase) || currentName.EndsWith("microsoft.com", StringComparison.CurrentCultureIgnoreCase)))
        {
            currentName = "lyle@luppes.com";
        }
        return currentName;
    }

    /// <summary>
    /// Returns UserId if logged on, empty if not
    /// </summary>
    /// <returns>UserId</returns>
    protected string GetUserId()
    {
        var currentUser = context.HttpContext.User;
        if (currentUser != null)
        {
            var userId = currentUser.FindFirst(ClaimTypes.NameIdentifier).Value;
            return userId;
        }
        return string.Empty;
    }

    /// <summary>
    /// Returns true if user is in Admin Role, false if not or not logged in
    /// </summary>
    /// <returns>Is Admin</returns>
    protected bool IsAdmin()
    {
        var currentUser = context?.HttpContext?.User;
        if (currentUser == null || currentUser.Identity == null || currentUser.Identity.Name == null ||
            currentUser.Identity.Name.ToUpper() == "UNKNOWN" || currentUser.Identity.Name.ToUpper() == "UNDEFINED")
        {
            return false;
            // return true;
        }
        else
        {
            var isUserAnAdmin = currentUser != null && currentUser.Identity != null && currentUser.Identity.Name.Contains("luppes");
            return isUserAnAdmin;
        }
        //if (currentUser != null)
        //{
        //    var isAdmin = currentUser.IsInRole("Admin");
        //    if (!isAdmin)
        //    {
        //        isAdmin = currentUser.HasClaim("groups", AppSettingsValues.AdminGroupId);
        //    }
        //    if (!isAdmin)
        //    {
        //        isAdmin = context.HttpContext.User.Identity.Name.ToLower().Contains("lyle@luppes.com");
        //    }
        //    return isAdmin;
        //}
        //return false;
    }
    #endregion

    #region Web Page Helpers
    /// <summary>
    /// Determines whether the specified HTTP request is an AJAX request.
    /// </summary>
    /// <returns>
    /// true if the specified HTTP request is an AJAX request; otherwise, false.
    /// </returns>
    protected bool IsAjaxRequest()
    {
        if (context?.HttpContext?.Request?.Headers != null)
        {
            return context.HttpContext.Request.Headers["X-Requested-With"] == "XMLHttpRequest";
        }
        return false;
    }
    #endregion

    #region Messages
    /// <summary>
    /// Write Info Message
    /// </summary>
    /// <param name="msg">Message</param>
    protected void WriteToLog(string msg)
    {
        Trace.WriteLine(msg);
    }

    /// <summary>
    /// Write Error Message
    /// </summary>
    /// <param name="msg">Message</param>
    protected void WriteSevereError(string msg)
    {
        Trace.WriteLine(msg);
    }

    /// <summary>
    /// Build one string from multiple nested error messages for logging
    /// </summary>
    /// <param name="ex">Exception</param>
    /// <returns>All the messages together</returns>
    protected string GetExceptionMessage(Exception ex)
    {
        var message = string.Empty;
        if (ex == null)
        {
            return message;
        }

        // ReSharper disable once ConditionIsAlwaysTrueOrFalse
        if (ex.Message != null)
        {
            message += ex.Message;
        }

        if (ex.InnerException == null)
        {
            return message;
        }

        // ReSharper disable once ConditionIsAlwaysTrueOrFalse
        if (ex.InnerException.Message != null)
        {
            message += " " + ex.InnerException.Message;
        }

        if (ex.InnerException.InnerException == null)
        {
            return message;
        }

        // ReSharper disable once ConditionIsAlwaysTrueOrFalse
        if (ex.InnerException.InnerException.Message != null)
        {
            message += " " + ex.InnerException.InnerException.Message;
        }

        if (ex.InnerException.InnerException.InnerException == null)
        {
            return message;
        }

        // ReSharper disable once ConditionIsAlwaysTrueOrFalse
        if (ex.InnerException.InnerException.InnerException.Message != null)
        {
            message += " " + ex.InnerException.InnerException.InnerException.Message;
        }

        return message;
    }
    #endregion

    #region Null Object Helpers
    /// <summary>
    /// Convert object to a valid string even if null
    /// </summary>
    /// <param name="o">Object</param>
    /// <returns>Value</returns>
    protected string CStrNull(object o)
    {
        return CStrNull(o, string.Empty);
    }

    /// <summary>
    /// Convert object to a valid string even if null
    /// </summary>
    /// <param name="o">Object</param>
    /// <param name="dflt">Default Value</param>
    /// <returns>Value</returns>
    protected string CStrNull(object o, string dflt)
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
    /// Convert object to a valid decimal even if null
    /// </summary>
    /// <param name="o">Object</param>
    /// <returns>Value</returns>
    protected decimal CDecNull(object o)
    {
        return CDecNull(o, 0);
    }

    /// <summary>
    /// Convert object to a valid decimal even if null
    /// </summary>
    /// <param name="o">Object</param>
    /// <param name="dflt">Default Value</param>
    /// <returns>Value</returns>
    protected decimal CDecNull(object o, decimal dflt)
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
    /// Convert object to a valid integer even if null
    /// </summary>
    /// <param name="o">Object</param>
    /// <returns>Value</returns>
    protected int CIntNull(object o)
    {
        return CIntNull(o, 0);
    }

    /// <summary>
    /// Convert object to a valid integer even if null
    /// </summary>
    /// <param name="o">Object</param>
    /// <param name="dflt">Default Value</param>
    /// <returns>Value</returns>
    protected int CIntNull(object o, int dflt)
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
    /// Convert object to a valid date time even if null
    /// </summary>
    /// <param name="o">Object</param>
    /// <returns>Value</returns>
    protected DateTime CDateNull(object o)
    {
        return CDateNull(o, DateTime.MinValue);
    }

    /// <summary>
    /// Convert object to a valid date time even if null
    /// </summary>
    /// <param name="o">Object</param>
    /// <param name="dflt">Default Value</param>
    /// <returns>Value</returns>
    protected DateTime CDateNull(object o, DateTime dflt)
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
    #endregion

    #region MVC Helpers
    /// <summary>
    /// Gets a list of errors in the model state and combines them into one simple string.
    /// Very useful for debugging if you get an error in your model, but you are not displaying the field on the screen so you don't know what it is.
    /// </summary>
    /// <param name="ms">Model State.</param>
    /// <returns>List of errors in one string.</returns>
    protected string ShowAllModelStateErrors(ModelStateDictionary ms)
    {
        //// if you have errors you can't find, set a breakpoint after the ModelState.IsValid and run this command in the Immediate Window:
        ////    ? ShowAllModelStateErrors(ModelState)
        //// OR -- if you want to use this more often, you can put it right into your controller & view
        ////   put code like this in your Controller
        ////      if (ModelState.IsValid)
        ////        {... do stuff here...}
        ////      else
        ////        ViewBag.allErrors = ShowAllModelStateErrors(ModelState);
        ////   put this somewhere in your view
        ////      @{ if (ViewBag.allErrors != null) { <!-- Errors: @ViewBag.allErrors  --> } }
        ////   now when you hit the screen again, those errors will be visible
        var errors = ms
          .Where(x => x.Value.Errors.Count > 0)
          .Select(x => new
          {
              x.Key,
              x.Value.Errors
          })
          .ToArray();
        var allErrors = string.Empty;
        foreach (var err in errors)
        {
            allErrors += err.Key + ": ";
            // ReSharper disable once LoopCanBeConvertedToQuery
            foreach (var e2 in err.Errors)
            {
                allErrors += e2.ErrorMessage + "; ";
            }
        }

        return allErrors;
    }

    /// <summary>
    /// Removes auto-populated audit fields from validation
    /// </summary>
    protected void RemoveAuditFieldsFromValidation()
    {
        RemoveAuditFieldsFromValidation(new[] { "CreateUserName", "CreateDateTime", "ChangeUserName", "ChangeDateTime" });
    }

    /// <summary>
    /// Removes auto-populated audit fields from validation
    /// </summary>
    /// <param name="fieldsToRemove">List of fields to remove from ModelState</param>
    protected void RemoveAuditFieldsFromValidation(string[] fieldsToRemove)
    {
        if (fieldsToRemove == null)
        {
            return;
        }
        foreach (var s in fieldsToRemove)
        {
            ModelState.Remove(s);
        }
    }
    #endregion

    #region Serialization Helpers
    /// <summary>
    /// Serializes an object to an XML stream
    /// </summary>
    /// <param name="obj">Object</param>
    /// <returns>String</returns>
    protected string SerializeObjectToXMLString(object obj)
    {
        var xs = new XmlSerializer(obj.GetType());
        var memoryStream = new MemoryStream();
        var xmlTextWriter = new XmlTextWriter(memoryStream, Encoding.UTF8) { Formatting = System.Xml.Formatting.Indented }; ////XmlTextWriter - fast, non-cached, forward-only way of generating streams or files containing XML data
        xs.Serialize(xmlTextWriter, obj); ////Serialize emp in the xmlTextWriter
        memoryStream = (MemoryStream)xmlTextWriter.BaseStream; ////Get the BaseStream of the xmlTextWriter in the Memory Stream6
        return UTF8ByteArrayToString(memoryStream.ToArray()); ////Convert to array
    }

    /// <summary>
    /// Serializes an object to an XML stream
    /// </summary>
    /// <param name="obj">Object</param>
    /// <returns>String</returns>
    protected byte[] SerializeObjectToXMLByteArray(object obj)
    {
        return StringToUTF8ByteArray(SerializeObjectToXMLString(obj)); // Convert to Byte Array
    }

    /// <summary>
    /// Serialize object to JSON string
    /// </summary>
    /// <param name="obj">Object</param>
    /// <returns>String</returns>
    protected string SerializeObjectToJsonString(object obj)
    {
        var json = JsonConvert.SerializeObject(obj, Newtonsoft.Json.Formatting.Indented);
        return json;
    }

    /// <summary>
    /// Serialize object to JSON Byte Array
    /// </summary>
    /// <param name="obj">Object</param>
    /// <returns>Byte Array</returns>
    protected byte[] SerializeObjectToJsonByteArray(object obj)
    {
        return Encoding.UTF8.GetBytes(SerializeObjectToJsonString(obj));
    }

    /// <summary>
    /// To convert a Byte Array of Unicode values (UTF-8 encoded) to a complete String.
    /// </summary>
    /// <param name="characters">Unicode Byte Array to be converted to String</param>
    /// <returns>String converted from Unicode Byte Array</returns>
    protected static string UTF8ByteArrayToString(byte[] characters)
    {
        var encoding = new UTF8Encoding();
        var constructedString = encoding.GetString(characters);
        return constructedString;
    }

    /// <summary>
    /// Converts the String to UTF8 Byte array and is used in De serialization
    /// </summary>
    /// <param name="stringToConvert">String to Convert</param>
    /// <returns>Byte Array</returns>
    protected byte[] StringToUTF8ByteArray(string stringToConvert)
    {
        var encoding = new UTF8Encoding();
        var byteArray = encoding.GetBytes(stringToConvert);
        return byteArray;
    }
    #endregion

    #region File Helpers
    /// <summary>
    /// Read file contents into a string
    /// </summary>
    /// <param name="fileName">File Name</param>
    /// <returns>File Contents</returns>
    protected static string GetFileContents(string fileName)
    {
        if (System.IO.File.Exists(fileName))
        {
            var reader = System.IO.File.OpenRead(fileName);
            var sb = new StringBuilder();
            var buffer = new byte[1024];
            var read = reader.Read(buffer, 0, buffer.Length);
            while (read > 0)
            {
                var str = Encoding.Default.GetString(buffer, 0, read);
                sb.Append(str);
                read = reader.Read(buffer, 0, buffer.Length);
            }
            reader.Close();
            return sb.ToString();
        }
        return string.Empty;
    }
    #endregion
}
