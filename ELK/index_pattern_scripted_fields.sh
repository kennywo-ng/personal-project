#this will display api called without the variables passed, after '?' are the var
#this is configured on kibana index pattern
if (doc['request.keyword'].size() > 0) {
    def url = doc['request.keyword'].value;
    def index = url.indexOf('?');
    if (index > 0) {
        return url.substring(0, index);
    } else {
        return url;
    }
}
return "";
