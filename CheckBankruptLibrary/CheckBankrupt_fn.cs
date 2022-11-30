using System;
using System.IO;
using System.Net;
using System.Xml;

namespace CheckBankruptLibrary
{    
    public class CheckBankrupt_fn
    {        
        //Функция проверяющая банкрот человек или нет по инн
        public static string CheckBankruptByINN(string _inn)
        {
            long _innToLong;

            ServicePointManager.SecurityProtocol = (SecurityProtocolType)3072;
            ServicePointManager.Expect100Continue = true;

            if (_inn.Length == 12)
            {
                try
                {
                    _innToLong = long.Parse(_inn);
                }
                catch(Exception)
                {
                    return "Неверно введен инн физ лица";
                }
            }
            else
            {
                return "Неверно введен инн физ лица";
            }

            string _testurl = @"https://services.fedresurs.ru/Bankruptcy/MessageServiceDemo/WebService.svc";
            //string _url = @"https://services.fedresurs.ru/Bankruptcy/MessageService/WebService.svc";
            string _method = @"http://tempuri.org/IMessageService/SearchDebtorByCode";
            string _soapenv = "";

            _soapenv += @"<s:Envelope xmlns:s=""http://schemas.xmlsoap.org/soap/envelope/"">" + '\n';
            _soapenv += @"  <s:Body xmlns:xsi=""http://www.w3.org/2001/XMLSchema-instance"" xmlns:xsd=""http://www.w3.org/2001/XMLSchema"">" + '\n';
            _soapenv += @"    <SearchDebtorByCode xmlns=""http://tempuri.org/"">" + '\n';
            _soapenv += @"      <codeType>PersonInn</codeType>" + '\n';
            _soapenv += @"      <codeValue>" + _inn + "</codeValue>" + '\n';
            _soapenv += @"    </SearchDebtorByCode>" + '\n';
            _soapenv += @"  </s:Body>" + '\n';
            _soapenv += @"</s:Envelope>";

            XmlDocument _soapEnv = new XmlDocument();
            _soapEnv.LoadXml(_soapenv);

            HttpWebRequest _request = CreateWebRequest(_testurl, _method);

            InsertSoapEnvToWebReq(_soapEnv, _request);

            string _soapResult;

            using (WebResponse _webResponse = _request.GetResponse())
            {
                using (StreamReader rd = new StreamReader(_webResponse.GetResponseStream()))
                {
                    _soapResult = rd.ReadToEnd();
                }
            }
            string _parsedXml;
            try
            {
                _parsedXml = XmlParse(_soapResult);
            }
            catch (Exception)
            {
                _parsedXml = "Инн не найден";
            }

            return _parsedXml;
        }

        //Функция для создания запроса
        private static HttpWebRequest CreateWebRequest(string _url, string _action)
        {
            string log = "demowebuser";
            string pass = "Ax!761BN";

            Uri _uri = new Uri(_url);

            HttpWebRequest _webRequest = (HttpWebRequest)WebRequest.Create(_uri);
            _webRequest.Headers.Add("SOAPAction", _action);
            _webRequest.ContentType = "text/xml;charset=\"utf-8\"";
            _webRequest.Accept = "text/xml";
            _webRequest.Method = "POST";

            var _credentialCache = new CredentialCache();
            _credentialCache.Add(new Uri(_uri.GetLeftPart(UriPartial.Authority)), "Digest", new NetworkCredential(log, pass));

            _webRequest.Credentials = _credentialCache;

            return _webRequest;
        }

        //Функция сохраняющая наш xml в запрос
        private static void InsertSoapEnvToWebReq(XmlDocument _soapEnv, HttpWebRequest _request)
        {
            using (Stream _stream = _request.GetRequestStream())
            {
                _soapEnv.Save(_stream);
            }
        }

        //Функция для выбора нужных значений из ответа сервиса
        private static string XmlParse(string _res)
        {
            XmlDocument xmlDoc = new XmlDocument();
            xmlDoc.LoadXml(_res);
            string _check = xmlDoc.GetElementsByTagName("ApplicantType")[0].InnerText;
            return _check;
        }
    }
}
