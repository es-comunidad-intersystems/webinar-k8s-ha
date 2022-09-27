/// 
/// Simple persistent class used to insert data
Class Data.Person Extends %Persistent
{

Property Name As %String;

Property Surname As %String;

Property City As %String;

Property SSN As %String;

/// Method that creates a new object and returns object id
ClassMethod Create(name As %String, surname As %String, city As %String, ssn As %String) As %Status
{
    set ret = $$$OK
    try {
        set object = ..%New()
        set object.Name = name
        set object.Surname = surname
        set object.City = city
        set object.SSN = ssn

        $$$ThrowOnError(object.%Save())
        set ret = object.%Id()

    } catch ex {
        set ret = ex.AsStatus()
    }
    quit ret
}

Storage Default
{
<Data name="PersonDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Name</Value>
</Value>
<Value name="3">
<Value>Surname</Value>
</Value>
<Value name="4">
<Value>City</Value>
</Value>
<Value name="5">
<Value>SSN</Value>
</Value>
</Data>
<DataLocation>^Data.PersonD</DataLocation>
<DefaultData>PersonDefaultData</DefaultData>
<IdLocation>^Data.PersonD</IdLocation>
<IndexLocation>^Data.PersonI</IndexLocation>
<StreamLocation>^Data.PersonS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
