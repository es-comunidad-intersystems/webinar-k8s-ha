Class API.Util
{

/// Create a simple web application
/// write ##class(API.Util).CreateWebApp("IRISCLUSTER", "/external/person", "API.RestHandler")
ClassMethod CreateWebApp(pNamespace As %String, pWebApp As %String, pDispatch As %String) As %Status
{
    set ret = $$$OK
    try {
        new $namespace

        set $namespace = "%SYS" 
        set webName = pWebApp 
        set webProperties("DispatchClass") = pDispatch 
        set webProperties("NameSpace") = pNamespace 
        set webProperties("Enabled") = 1 
        set webProperties("AutheEnabled") = 64
        set webProperties("MatchRoles") = ":%All" 
        $$$ThrowOnError(##class(Security.Applications).Create(webName, .webProperties))

    } catch ex {
        set ret = ex.AsStatus()
    } 
    quit ret
}

}
