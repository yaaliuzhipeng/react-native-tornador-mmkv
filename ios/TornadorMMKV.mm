// TornadorMmkv.m

#import "TornadorMMKV.h"
#import <React/RCTBridge+Private.h>
#import <React/RCTUtils.h>
#import "jsi/jsi.h"
#import <MMKV/MMKV.h>

using namespace std;
using namespace facebook;

struct itype {
    string name;
    double value;
};
const itype _BOOL{"bool",1};
const itype DOUBLE{ "double",2};
const itype INT{ "i32",3};
const itype INT64{ "i64",4};
const itype UINT{ "ui32",5};
const itype UINT64{ "ui64",6};

class JSI_EXPORT MMKVHostObject : public jsi::HostObject {
private:
    const string fGetValue = "getValue";
    const string fSetValue = "setValue";
    const string fContainsKey = "containsKey";
    const string fRemoveValue = "removeValue";
    const string fAllKeys = "allKeys";
    const string fClear = "clear";
    
    shared_ptr<jsi::Value> getValuePtr;
    shared_ptr<jsi::Value> setValuePtr;
    shared_ptr<jsi::Value> containsKeyPtr;
    shared_ptr<jsi::Value> removeValuePtr;
    shared_ptr<jsi::Value> allKeysPtr;
    shared_ptr<jsi::Value> clearPtr;
    
    static MMKV* getMMKVInstance(jsi::Runtime &rt,const jsi::Value &id) {
        MMKV *ins;
        if(id.isString()) {
            ins = [MMKV mmkvWithID:[NSString stringWithUTF8String:id.toString(rt).utf8(rt).data()]];
        }else{
            ins = [MMKV defaultMMKV];
        }
        return ins;
    }
public:
    
    MMKVHostObject(){}
    
    vector<jsi::PropNameID> getPropertyNames(jsi::Runtime& rt) {
        vector<jsi::PropNameID> pnames = vector<jsi::PropNameID>();
        pnames.push_back(jsi::PropNameID::forAscii(rt,fGetValue));
        pnames.push_back(jsi::PropNameID::forAscii(rt,fSetValue));
        pnames.push_back(jsi::PropNameID::forAscii(rt,fContainsKey));
        pnames.push_back(jsi::PropNameID::forAscii(rt,fRemoveValue));
        pnames.push_back(jsi::PropNameID::forAscii(rt,fAllKeys));
        pnames.push_back(jsi::PropNameID::forAscii(rt,fClear));
        
        pnames.push_back(jsi::PropNameID::forAscii(rt,_BOOL.name));
        pnames.push_back(jsi::PropNameID::forAscii(rt,DOUBLE.name));
        pnames.push_back(jsi::PropNameID::forAscii(rt,INT.name));
        pnames.push_back(jsi::PropNameID::forAscii(rt,INT64.name));
        pnames.push_back(jsi::PropNameID::forAscii(rt,UINT.name));
        pnames.push_back(jsi::PropNameID::forAscii(rt,UINT64.name));
        return pnames;
    }
    jsi::Value get(jsi::Runtime& jsiRuntime,const jsi::PropNameID& name) {
        if(name.utf8(jsiRuntime) == _BOOL.name) return jsi::Value(_BOOL.value);
        if(name.utf8(jsiRuntime) == DOUBLE.name) return jsi::Value(DOUBLE.value);
        if(name.utf8(jsiRuntime) == INT.name) return jsi::Value(INT.value);
        if(name.utf8(jsiRuntime) == INT64.name) return jsi::Value(INT64.value);
        if(name.utf8(jsiRuntime) == UINT.name) return jsi::Value(UINT.value);
        if(name.utf8(jsiRuntime) == UINT64.name) return jsi::Value(UINT64.value);
        
        if(name.utf8(jsiRuntime) == fGetValue){
            if(getValuePtr == nullptr){
                auto value = jsi::Function::createFromHostFunction(jsiRuntime,jsi::PropNameID::forUtf8(jsiRuntime,fGetValue),3,[](jsi::Runtime& rt, const jsi::Value& thisVal, const jsi::Value* args, size_t count) -> jsi::Value {
                    MMKV *ins = getMMKVInstance(rt,args[0]);
                    
                    NSString *nskey = [NSString stringWithUTF8String:args[1].toString(rt).utf8(rt).data()];
                    double ktype = args[2].getNumber();
                    if(ktype == _BOOL.value){
                        return jsi::Value([ins getBoolForKey:nskey defaultValue: NO]);
                    }else if(ktype == DOUBLE.value){
                        return jsi::Value([ins getDoubleForKey:nskey defaultValue:-1.0]);
                    }else if(ktype == INT.value){
                        return jsi::Value([ins getInt32ForKey:nskey defaultValue:-1]);
                    }else if(ktype == INT64.value){
                        return jsi::Value((double)[ins getInt64ForKey:nskey defaultValue:-1]);
                    }else if(ktype == UINT.value){
                        return jsi::Value((int)[ins getUInt32ForKey:nskey defaultValue:-1]);
                    }else if(ktype == UINT64.value){
                        return jsi::Value((double)[ins getUInt64ForKey:nskey defaultValue:-1]);
                    }
                    string result = "";
                    NSString* nsresult = [ins getStringForKey:nskey defaultValue:@""];
                    return jsi::String::createFromUtf8(rt,nsresult.UTF8String);
                });
                getValuePtr = make_shared<jsi::Value>(move(value));
            }
            return getValuePtr->asObject(jsiRuntime).asFunction(jsiRuntime);
        }
        if(name.utf8(jsiRuntime) == fSetValue) {
            if(setValuePtr == nullptr){
                auto value = jsi::Function::createFromHostFunction(jsiRuntime,jsi::PropNameID::forUtf8(jsiRuntime,fSetValue),4,[](jsi::Runtime& rt, const jsi::Value& thisVal, const jsi::Value* args, size_t count) -> jsi::Value {
                    MMKV *ins = getMMKVInstance(rt,args[0]);
                    
                    NSString *nskey = [NSString stringWithUTF8String:args[2].toString(rt).utf8(rt).data()];
                    double ktype = args[3].getNumber();
                    
                    if(ktype == _BOOL.value){
                        return jsi::Value([ins setBool:args[1].getBool() forKey:nskey]);
                    }else if(ktype == DOUBLE.value){
                        return jsi::Value([ins setDouble:args[1].getNumber() forKey:nskey]);
                    }else if(ktype == INT.value){
                        return jsi::Value([ins setInt32:(int32_t)args[1].getNumber() forKey:nskey]);
                    }else if(ktype == INT64.value){
                        return jsi::Value([ins setInt64:(int64_t)args[1].getNumber() forKey:nskey]);
                    }else if(ktype == UINT.value){
                        return jsi::Value([ins setUInt32:(uint32_t)args[1].getNumber() forKey:nskey]);
                    }else if(ktype == UINT64.value){
                        return jsi::Value([ins setUInt64:(uint64_t)args[1].getNumber() forKey:nskey]);
                    }
                    
                    BOOL ok = [ins setString:[NSString stringWithUTF8String:args[1].toString(rt).utf8(rt).data()] forKey:nskey];
                    return jsi::Value(ok);
                });
                setValuePtr = make_shared<jsi::Value>(move(value));
            }
            return setValuePtr->asObject(jsiRuntime).asFunction(jsiRuntime);
        }
        if(name.utf8(jsiRuntime) == fContainsKey) {
            if(containsKeyPtr == nullptr){
                auto value = jsi::Function::createFromHostFunction(jsiRuntime,jsi::PropNameID::forUtf8(jsiRuntime,fContainsKey),2,[](jsi::Runtime& rt, const jsi::Value& thisVal, const jsi::Value* args, size_t count) -> jsi::Value {
                    MMKV *ins = getMMKVInstance(rt,args[0]);
                    BOOL yes = [ins containsKey:[NSString stringWithUTF8String:args[1].toString(rt).utf8(rt).data()]];
                    return jsi::Value(yes);
                });
                containsKeyPtr = make_shared<jsi::Value>(move(value));
            }
            return containsKeyPtr->asObject(jsiRuntime).asFunction(jsiRuntime);
        }
        if(name.utf8(jsiRuntime) == fRemoveValue) {
            if(removeValuePtr == nullptr){
                auto value = jsi::Function::createFromHostFunction(jsiRuntime,jsi::PropNameID::forUtf8(jsiRuntime,fRemoveValue),2,[](jsi::Runtime& rt, const jsi::Value& thisVal, const jsi::Value* args, size_t count) -> jsi::Value {
                    MMKV *ins = getMMKVInstance(rt,args[0]);
                    [ins removeValueForKey:[NSString stringWithUTF8String:args[1].toString(rt).utf8(rt).data()]];
                    return jsi::Value::undefined();
                });
                removeValuePtr = make_shared<jsi::Value>(move(value));
            }
            return removeValuePtr->asObject(jsiRuntime).asFunction(jsiRuntime);
        }
        if(name.utf8(jsiRuntime) == fAllKeys) {
            if(allKeysPtr == nullptr){
                auto value = jsi::Function::createFromHostFunction(jsiRuntime,jsi::PropNameID::forUtf8(jsiRuntime,fAllKeys),1,[](jsi::Runtime& rt, const jsi::Value& thisVal, const jsi::Value* args, size_t count) -> jsi::Value {
                    MMKV *ins = getMMKVInstance(rt,args[0]);
                    auto allkeys = jsi::Array::createWithElements(rt,{});
                    NSArray *nskeys = [ins allKeys];
                    for(NSString *key in nskeys){
                        allkeys.setValueAtIndex(rt,0,jsi::String::createFromUtf8(rt,key.UTF8String));
                    }
                    return allkeys;
                });
                allKeysPtr = make_shared<jsi::Value>(move(value));
            }
            return allKeysPtr->asObject(jsiRuntime).asFunction(jsiRuntime);
        }
        if(name.utf8(jsiRuntime) == fClear) {
            if(clearPtr == nullptr){
                auto value = jsi::Function::createFromHostFunction(jsiRuntime,jsi::PropNameID::forUtf8(jsiRuntime,fClear),1,[](jsi::Runtime& rt, const jsi::Value& thisVal, const jsi::Value* args, size_t count) -> jsi::Value {
                    MMKV *ins = getMMKVInstance(rt,args[0]);
                    [ins clearAll];
                    return jsi::Value::undefined();
                });
                clearPtr = make_shared<jsi::Value>(move(value));
            }
            return clearPtr->asObject(jsiRuntime).asFunction(jsiRuntime);
        }

        return jsi::Value::undefined();
    }
    void set(jsi::Runtime&, const jsi::PropNameID& name, const jsi::Value& value){
    //ignore set
    }

};



@implementation TornadorMMKV
{
    shared_ptr<MMKVHostObject> sharedPtr;
}

RCT_EXPORT_MODULE(TornadorMMKV)


+ (BOOL)requiresMainQueueSetup {
    return YES;
}

RCT_EXPORT_BLOCKING_SYNCHRONOUS_METHOD(install)
{
    
    RCTBridge* bridge = [RCTBridge currentBridge];
    RCTCxxBridge* cxxBridge = (RCTCxxBridge*) bridge;
    if(cxxBridge == nil) return nil;
    auto jsiRuntime = (jsi::Runtime *) cxxBridge.runtime;
    jsi::Runtime &runtime = *jsiRuntime;
    
    RCTUnsafeExecuteOnMainQueueSync(^{
        [MMKV initializeMMKV: nil];
    });
    
    if(sharedPtr == nullptr){
        MMKVHostObject mmkvHostObject = MMKVHostObject();
        sharedPtr = make_shared<MMKVHostObject>(mmkvHostObject);
        auto nativeObject = jsi::Object::createFromHostObject(runtime, sharedPtr);
        jsiRuntime->global().setProperty(runtime, "__nativeTornadorMMKV", move(nativeObject));
    }
    return nil;
}

@end
