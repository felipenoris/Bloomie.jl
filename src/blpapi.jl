# datatypes

mutable struct blpapi_CorrelationId
    # unsigned int  size:8;       // fill in the size of this struct
    # unsigned int  valueType:4;  // type of value held by this correlation id
    # unsigned int  classId:16;   // user defined classification id
    # unsigned int  reserved:4;   // for internal use must be 0
    size_valueType_classId_reserved::UInt32
    value::UInt64 # union not supported
end

mutable struct blpapi_Datetime
    parts::UInt8
    hours::UInt8
    minutes::UInt8
    seconds::UInt8
    milliSeconds::UInt16
    month::UInt8
    day::UInt8
    year::UInt16
    offset::Int16
end

# macros

function blpapi_getLastErrorDescription(resultCode)
    unsafe_string(ccall((:blpapi_getLastErrorDescription, blpapi), Cstring, (Cint,), Int32(resultCode)))
end

macro check(fn)
    quote
        res = $(esc(fn))
        if res > 0; error(blpapi_getLastErrorDescription(res)); end
    end
end

macro with_pointer(var,body)
    quote
        $(esc(var)) = Ref{Ptr{Cvoid}}(0)
        $(esc(body))
        $(esc(var))[]
    end
end

# session

function blpapi_getVersionInfo(majorVersion, minorVersion, patchVersion, buildVersion)
    ccall((:blpapi_getVersionInfo, blpapi), Cvoid, (Ref{Cint}, Ref{Cint}, Ref{Cint}, Ref{Cint}), majorVersion, minorVersion, patchVersion, buildVersion)
end

function blpapi_EventDispatcher_create(numDispatcherThreads)
    ccall((:blpapi_EventDispatcher_create, blpapi), Ptr{Cvoid}, (Cint,), Int32(numDispatcherThreads))
end

function blpapi_SessionOptions_create()
    ccall((:blpapi_SessionOptions_create, blpapi), Ptr{Cvoid}, ())
end

function blpapi_SessionOptions_destroy(parameters)
    ccall((:blpapi_SessionOptions_destroy, blpapi), Cvoid, (Ptr{Cvoid},), parameters)
end

function blpapi_SessionOptions_setServerHost(parameters, serverHost)
    @check ccall((:blpapi_SessionOptions_setServerHost, blpapi), Cint, (Ptr{Cvoid}, Cstring), parameters, serverHost)
end

function blpapi_SessionOptions_setServerPort(parameters, serverPort)
    @check ccall((:blpapi_SessionOptions_setServerPort, blpapi), Cint, (Ptr{Cvoid}, UInt16), parameters, UInt16(serverPort))
end

function blpapi_Session_create(parameters, handler, dispatcher, userData)
    ccall((:blpapi_Session_create, blpapi), Ptr{Cvoid}, (Ptr{Cvoid}, Ptr{Cvoid}, Ptr{Cvoid}, Ptr{Cvoid}), parameters, handler, dispatcher, userData)
end

function blpapi_Session_destroy(session)
    ccall((:blpapi_Session_destroy, blpapi), Cvoid, (Ptr{Cvoid},), session)
end

function blpapi_Session_start(session)
    @check ccall((:blpapi_Session_start, blpapi), Cint, (Ptr{Cvoid},), session)
end

function blpapi_Session_stop(session)
    @check ccall((:blpapi_Session_stop, blpapi), Cint, (Ptr{Cvoid},), session)
end

function blpapi_Session_getService(session, service, serviceName)
    @check ccall((:blpapi_Session_getService, blpapi), Cint, (Ptr{Cvoid}, Ref{Ptr{Cvoid}}, Cstring), session, service, serviceName)
end

function blpapi_Session_openService(session, serviceName)
    @check ccall((:blpapi_Session_openService, blpapi), Cint, (Ptr{Cvoid}, Cstring), session, serviceName)
end

function blpapi_Service_name(service)
    unsafe_string(ccall((:blpapi_Service_name, blpapi), Cstring, (Ptr{Cvoid},), service))
end

function blpapi_Service_release(service)
    ccall((:blpapi_Service_release, blpapi), Cvoid, (Ptr{Cvoid},), service)
end

function blpapi_Service_numOperations(service)
    ccall((:blpapi_Service_numOperations, blpapi), Cint, (Ptr{Cvoid},), service)
end

function blpapi_Service_numEventDefinitions(service)
    ccall((:blpapi_Service_numEventDefinitions, blpapi), Cint, (Ptr{Cvoid},), service)
end

function blpapi_Service_getOperationAt(service, operation, index)
    @check ccall((:blpapi_Service_getOperationAt, blpapi), Cint, (Ptr{Cvoid}, Ref{Ptr{Cvoid}}, Cint), service, operation, Int32(index))
end

function blpapi_Service_getEventDefinitionAt(service, result, index)
    @check ccall((:blpapi_Service_getEventDefinitionAt, blpapi), Cint, (Ptr{Cvoid}, Ref{Ptr{Cvoid}}, Cint), service, result, Int32(index))
end

function blpapi_Operation_name(service)
    unsafe_string(ccall((:blpapi_Operation_name, blpapi), Cstring, (Ptr{Cvoid},), service))
end

function blpapi_SchemaElementDefinition_name(field)
    ccall((:blpapi_SchemaElementDefinition_name, blpapi), Ptr{Cvoid}, (Ptr{Cvoid},), field)
end

function blpapi_Name_string(name)
    unsafe_string(ccall((:blpapi_Name_string, blpapi), Cstring, (Ptr{Cvoid},), name))
end

function blpapi_Name_destroy(name)
    ccall((:blpapi_Name_destroy, blpapi), Cvoid, (Ptr{Cvoid},), name)
end

# response

function blpapi_Session_nextEvent(session, eventPointer, timeoutInMilliseconds)
    @check ccall((:blpapi_Session_nextEvent, blpapi), Cint, (Ptr{Cvoid}, Ref{Ptr{Cvoid}}, UInt32), session, eventPointer, UInt32(timeoutInMilliseconds))
end

function blpapi_Event_eventType(event)
    ccall((:blpapi_Event_eventType, blpapi), Cint, (Ptr{Cvoid},), event)
end

function blpapi_Event_release(event)
    @check ccall((:blpapi_Event_release, blpapi), Cint, (Ptr{Cvoid},), event)
end

function blpapi_Element_getValueAsBool(element, buffer, index)
    @check ccall((:blpapi_Element_getValueAsBool, blpapi), Cint, (Ptr{Cvoid}, Ref{Int32}, Cint), element, buffer, Int32(index))
end

function blpapi_Element_getValueAsInt32(element, buffer, index)
    @check ccall((:blpapi_Element_getValueAsInt32, blpapi), Cint, (Ptr{Cvoid}, Ref{Int32}, Cint), element, buffer, Int32(index))
end

function blpapi_Element_getValueAsInt64(element, buffer, index)
    @check ccall((:blpapi_Element_getValueAsInt64, blpapi), Cint, (Ptr{Cvoid}, Ref{Int64}, Cint), element, buffer, Int32(index))
end

function blpapi_Element_getValueAsFloat32(element, buffer, index)
    @check ccall((:blpapi_Element_getValueAsFloat32, blpapi), Cint, (Ptr{Cvoid}, Ref{Float32}, Cint), element, buffer, Int32(index))
end

function blpapi_Element_getValueAsFloat64(element, buffer, index)
    @check ccall((:blpapi_Element_getValueAsFloat64, blpapi), Cint, (Ptr{Cvoid}, Ref{Float64}, Cint), element, buffer, Int32(index))
end

function blpapi_Element_getValueAsString(element, buffer, index)
    @check ccall((:blpapi_Element_getValueAsString, blpapi), Cint, (Ptr{Cvoid}, Ref{Ptr{UInt8}}, Cint), element, buffer, Int32(index))
end

function blpapi_Element_getValueAsDatetime(element, buffer, index)
    @check ccall((:blpapi_Element_getValueAsDatetime, blpapi), Cint, (Ptr{Cvoid}, Ref{blpapi_Datetime}, Cint), element, buffer, Int32(index))
end

function blpapi_Element_datatype(element)
    ccall((:blpapi_Element_datatype, blpapi), Cint, (Ptr{Cvoid},), element)
end

function blpapi_Element_isArray(element)
    ccall((:blpapi_Element_isArray, blpapi), Cint, (Ptr{Cvoid},), element)
end

function blpapi_Element_nameString(element)
    unsafe_string(ccall((:blpapi_Element_nameString, blpapi), Cstring, (Ptr{Cvoid},), element))
end

function blpapi_Element_numValues(element)
    ccall((:blpapi_Element_numValues, blpapi), Cint, (Ptr{Cvoid},), element)
end

function blpapi_Element_numElements(element)
    ccall((:blpapi_Element_numElements, blpapi), Cint, (Ptr{Cvoid},), element)
end

function blpapi_Element_getElementAt(element, result, position)
    @check ccall((:blpapi_Element_getElementAt, blpapi), Cint, (Ptr{Cvoid}, Ref{Ptr{Cvoid}}, Cint), element, result, Int32(position))
end

function blpapi_Element_getValueAsElement(element, buffer, index)
    @check ccall((:blpapi_Element_getValueAsElement, blpapi), Cint, (Ptr{Cvoid}, Ref{Ptr{Cvoid}}, Cint), element, buffer, Int32(index))
end

function blpapi_Element_hasElement(element, nameString, name)
    Bool(ccall((:blpapi_Element_hasElement, blpapi), Cint, (Ptr{Cvoid}, Cstring, Ptr{Cvoid}), element, nameString, name))
end

function blpapi_Element_appendElement(element, appendedElement)
    @check ccall((:blpapi_Element_appendElement, blpapi), Cint, (Ptr{Cvoid}, Ref{Ptr{Cvoid}}), element, appendedElement)
end

function blpapi_Element_getChoice(element, result)
    @check ccall((:blpapi_Element_getChoice, blpapi), Cint, (Ptr{Cvoid}, Ref{Ptr{Cvoid}}), element, result)
end

function blpapi_MessageIterator_create(event)
    ccall((:blpapi_MessageIterator_create, blpapi), Ptr{Cvoid}, (Ptr{Cvoid},), event)
end

function blpapi_MessageIterator_destroy(iterator)
    ccall((:blpapi_MessageIterator_destroy, blpapi), Cvoid, (Ptr{Cvoid},), iterator)
end

function blpapi_Message_numCorrelationIds(message)
    ccall((:blpapi_Message_numCorrelationIds, blpapi), Cint, (Ptr{Cvoid},), message)
end

function blpapi_Message_correlationId(message, index)
    ccall((:blpapi_Message_correlationId, blpapi), blpapi_CorrelationId, (Ptr{Cvoid}, Cint), message, Int32(index))
end

function blpapi_Message_elements(message)
    ccall((:blpapi_Message_elements, blpapi), Ptr{Cvoid}, (Ptr{Cvoid},), message)
end

function blpapi_Message_typeString(message)
    unsafe_string(ccall((:blpapi_Message_typeString, blpapi), Cstring, (Ptr{Cvoid},), message))
end

function blpapi_Message_release(message)
    @check ccall((:blpapi_Message_release, blpapi), Cint, (Ptr{Cvoid},), message)
end

function blpapi_MessageIterator_next(iterator, result)
    @check ccall((:blpapi_MessageIterator_next, blpapi), Cint, (Ptr{Cvoid}, Ref{Ptr{Cvoid}}), iterator, result)
end

# request

function blpapi_Element_getElement(element, result, nameString, name)
    @check ccall((:blpapi_Element_getElement, blpapi), Cint, (Ptr{Cvoid}, Ref{Ptr{Cvoid}}, Cstring, Ptr{Cvoid}), element, result, nameString, name)
end

function blpapi_Element_setElementString(element, nameString, name, value)
    @check ccall((:blpapi_Element_setElementString, blpapi), Cint, (Ptr{Cvoid}, Cstring, Ptr{Cvoid}, Cstring), element, nameString, name, value)
end

function blpapi_Element_setElementInt32(element, nameString, name, value)
    @check ccall((:blpapi_Element_setElementInt32, blpapi), Cint, (Ptr{Cvoid}, Cstring, Ptr{Cvoid}, Int32), element, nameString, name, Int32(value))
end

function blpapi_Element_setValueString(element, value, index)
    @check ccall((:blpapi_Element_setValueString, blpapi), Cint, (Ptr{Cvoid}, Cstring, Cint), element, value, Int32(index))
end

function blpapi_Session_sendRequest(session, request, correlationId, identity, eventQueue, requestLabel, requestLabelLen)
    @check ccall((:blpapi_Session_sendRequest, blpapi), Cint, (Ptr{Cvoid}, Ptr{Cvoid}, Ref{blpapi_CorrelationId}, Ptr{Cvoid}, Ptr{Cvoid}, Cstring, Cint), session, request, correlationId, identity, eventQueue, requestLabel, Int32(requestLabelLen))
end

function blpapi_Service_createRequest(service, request, operation)
    @check ccall((:blpapi_Service_createRequest, blpapi), Cint, (Ptr{Cvoid}, Ref{Ptr{Cvoid}}, Cstring), service, request, operation)
end

function blpapi_Request_elements(request)
    ccall((:blpapi_Request_elements, blpapi), Ptr{Cvoid}, (Ptr{Cvoid},), request)
end

function blpapi_Request_destroy(request)
    ccall((:blpapi_Request_destroy, blpapi), Cvoid, (Ptr{Cvoid},), request)
end
