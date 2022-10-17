/// Simple REST API
Class API.RestHandler Extends %CSP.REST
{

Parameter HandleCorsRequest As %Integer = 1;

XData UrlMap
{
<Routes>
<Route Url="/:id" Method="GET" Call="PersonGet"/>
</Routes>
}

/// Return a person object
ClassMethod PersonGet(id As %String) As %Status
{
    set obj = ##class(Data.Person).%OpenId(id)
    if '$isobject(obj) {
    	set %response.Status = "404"
    	quit ""
    }
    set %response.ContentType = "application/json"
    set %response.Status = "200"
    do obj.%JSONExport()
    
    quit $$$OK
}

}
