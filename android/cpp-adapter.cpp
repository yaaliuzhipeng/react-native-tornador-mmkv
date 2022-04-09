#include <jni.h>
#include <fbjni/fbjni.h>
#include <jsi/jsi.h>
#include <android/log.h>
#include <CallInvokerHolder.h>
#include <ReactCommon/CallInvoker.h>
#include <MMKV.h>

#define TAG "Tornador"
#define logd(...) __android_log_print(ANDROID_LOG_DEBUG,TAG ,__VA_ARGS__)
#define logi(...) __android_log_print(ANDROID_LOG_INFO,TAG ,__VA_ARGS__)
#define logw(...) __android_log_print(ANDROID_LOG_WARN,TAG ,__VA_ARGS__)
#define loge(...) __android_log_print(ANDROID_LOG_ERROR,TAG ,__VA_ARGS__)
#define logf(...) __android_log_print(ANDROID_LOG_FATAL,TAG ,__VA_ARGS__)

using namespace std;
using namespace facebook;

struct itype {
    string name;
    double value;
};
const itype BOOL{"bool",1};
const itype DOUBLE{ "double",2};
const itype INT{ "i32",3};
const itype INT64{ "i64",4};
const itype UINT{ "ui32",5};
const itype UINT64{ "ui64",6};

class MMKVHostObject : public jsi::HostObject {

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
            ins = MMKV::mmkvWithID(id.toString(rt).utf8(rt).data());
        }else{
            ins = MMKV::defaultMMKV();
        }
        return ins;
    }
public:
    MMKVHostObject(){}
    ~MMKVHostObject(){}

    std::vector<jsi::PropNameID> getPropertyNames(jsi::Runtime &rt) override {
        std::vector<jsi::PropNameID> pnames = std::vector<jsi::PropNameID>();
        pnames.push_back(jsi::PropNameID::forAscii(rt,fGetValue));
        pnames.push_back(jsi::PropNameID::forAscii(rt,fSetValue));
        pnames.push_back(jsi::PropNameID::forAscii(rt,fContainsKey));
        pnames.push_back(jsi::PropNameID::forAscii(rt,fRemoveValue));
        pnames.push_back(jsi::PropNameID::forAscii(rt,fAllKeys));
        pnames.push_back(jsi::PropNameID::forAscii(rt,fClear));

        pnames.push_back(jsi::PropNameID::forAscii(rt,BOOL.name));
        pnames.push_back(jsi::PropNameID::forAscii(rt,DOUBLE.name));
        pnames.push_back(jsi::PropNameID::forAscii(rt,INT.name));
        pnames.push_back(jsi::PropNameID::forAscii(rt,INT64.name));
        pnames.push_back(jsi::PropNameID::forAscii(rt,UINT.name));
        pnames.push_back(jsi::PropNameID::forAscii(rt,UINT64.name));
        return pnames;
    }
    jsi::Value get(jsi::Runtime &jsiRuntime, const jsi::PropNameID &name) override {
        if(name.utf8(jsiRuntime) == BOOL.name) return jsi::Value(BOOL.value);
        if(name.utf8(jsiRuntime) == DOUBLE.name) return jsi::Value(DOUBLE.value);
        if(name.utf8(jsiRuntime) == INT.name) return jsi::Value(INT.value);
        if(name.utf8(jsiRuntime) == INT64.name) return jsi::Value(INT64.value);
        if(name.utf8(jsiRuntime) == UINT.name) return jsi::Value(UINT.value);
        if(name.utf8(jsiRuntime) == UINT64.name) return jsi::Value(UINT64.value);

        if(name.utf8(jsiRuntime) == fGetValue){
            if(getValuePtr == nullptr){
                auto value = jsi::Function::createFromHostFunction(jsiRuntime,jsi::PropNameID::forUtf8(jsiRuntime,fGetValue),3,[](jsi::Runtime& rt, const jsi::Value& thisVal, const jsi::Value* args, size_t count) -> jsi::Value {
                    MMKV *ins = getMMKVInstance(rt,args[0]);
                    string key = args[1].toString(rt).utf8(rt);
                    double ktype = args[2].getNumber();
                    if(ktype == BOOL.value){
                        return jsi::Value(ins->getBool(key));
                    }else if(ktype == DOUBLE.value){
                        return jsi::Value(ins->getDouble(key,-1));
                    }else if(ktype == INT.value){
                        return jsi::Value(ins->getInt32(key,-1));
                    }else if(ktype == INT64.value){
                        return jsi::Value((double)ins->getInt64(key,-1));
                    }else if(ktype == UINT.value){
                        return jsi::Value((int)ins->getUInt32(key,-1));
                    }else if(ktype == UINT64.value){
                        return jsi::Value((double)ins->getUInt64(key,-1));
                    }
                    //string
                    string result = "";
                    ins->getString(args[1].toString(rt).utf8(rt),result);
                    return jsi::String::createFromUtf8(rt,result);
                });
                getValuePtr = make_shared<jsi::Value>(move(value));
            }
            return getValuePtr->asObject(jsiRuntime).asFunction(jsiRuntime);
        }
        if(name.utf8(jsiRuntime) == fSetValue) {
            if(setValuePtr == nullptr){
                auto value = jsi::Function::createFromHostFunction(jsiRuntime,jsi::PropNameID::forUtf8(jsiRuntime,fSetValue),4,[](jsi::Runtime& rt, const jsi::Value& thisVal, const jsi::Value* args, size_t count) -> jsi::Value {
                    // arg0 => key ; arg1 => value ; arg2 => key ; arg3 => type ;
                    MMKV *ins = getMMKVInstance(rt,args[0]);
                    string key = args[2].toString(rt).utf8(rt);
                    double ktype = args[3].getNumber();
                    if(ktype == BOOL.value){
                        return jsi::Value(ins->set(args[1].getBool(),key));
                    }else if(ktype == DOUBLE.value){
                        return jsi::Value(ins->set(args[1].getNumber(),key));
                    }else if(ktype == INT.value){
                        return jsi::Value(ins->set((int32_t)args[1].getNumber(),key));
                    }else if(ktype == INT64.value){
                        return jsi::Value(ins->set((int64_t)args[1].getNumber(),key));
                    }else if(ktype == UINT.value){
                        return jsi::Value(ins->set((uint32_t)args[1].getNumber(),key));
                    }else if(ktype == UINT64.value){
                        return jsi::Value(ins->set((uint64_t)args[1].getNumber(),key));
                    }
                    //string
                    return jsi::Value(ins->set(args[1].toString(rt).utf8(rt),key));
                });
                setValuePtr = make_shared<jsi::Value>(move(value));
            }
            return setValuePtr->asObject(jsiRuntime).asFunction(jsiRuntime);
        }
        if(name.utf8(jsiRuntime) == fContainsKey) {
            if(containsKeyPtr == nullptr){
                auto value = jsi::Function::createFromHostFunction(jsiRuntime,jsi::PropNameID::forUtf8(jsiRuntime,fContainsKey),2,[](jsi::Runtime& rt, const jsi::Value& thisVal, const jsi::Value* args, size_t count) -> jsi::Value {
                    MMKV *ins = getMMKVInstance(rt,args[0]);
                    bool yes = ins->containsKey(args[1].toString(rt).utf8(rt));
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
                    ins->removeValueForKey(args[1].toString(rt).utf8(rt));
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
                    vector<string> keys = ins->allKeys();
                    auto allkeys = jsi::Array::createWithElements(rt,{});
                    for(string key:keys) {
                        allkeys.setValueAtIndex(rt,0,jsi::String::createFromUtf8(rt,key));
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
                    ins->clearAll();
                    return jsi::Value::undefined();
                });
                clearPtr = make_shared<jsi::Value>(move(value));
            }
            return clearPtr->asObject(jsiRuntime).asFunction(jsiRuntime);
        }

        return jsi::Value::undefined();
    }
    void set(jsi::Runtime &jsiRuntime, const jsi::PropNameID &name, const jsi::Value &value) override {
        //ignore-set
    }

};

shared_ptr<MMKVHostObject> sharedPtr;

struct TornadorMMKVModule: jni::JavaClass<TornadorMMKVModule> {
    static constexpr auto kJavaDescriptor = "Lcom/tornador/mmkv/TornadorMMKVModule;";
    static void registerNatives(){
        javaClassLocal()->registerNatives({
            makeNativeMethod("nativeInstall",TornadorMMKVModule::nativeInstall)
        });
    }
private:
    /**
     * Java中native方法均在此处进行声明定义；静态方法用 alias_ref<JClass>, 实例方法用 alias_ref<YourClass>
     */
    static void nativeInstall(jni::alias_ref<TornadorMMKVModule> thiz, jlong jsiContext,jni::alias_ref<facebook::react::CallInvokerHolder::javaobject> callInvokerHolder,jni::alias_ref<jni::JString> dir) {
        jsi::Runtime *runtime = reinterpret_cast<jsi::Runtime *>(jsiContext);
        jsi::Runtime &jsiRuntime = *runtime;
        shared_ptr<react::CallInvoker> callInvoker = callInvokerHolder->cthis()->getCallInvoker();
        /**
         *  Host Object
         */
        MMKV::initializeMMKV(dir->toStdString());
        MMKV::setLogLevel(MMKVLogLevel::MMKVLogNone);

        if(sharedPtr == nullptr) {
            MMKVHostObject mmkvHostObject = MMKVHostObject();
            sharedPtr = make_shared<MMKVHostObject>(mmkvHostObject);
            auto nativeObject = jsi::Object::createFromHostObject(jsiRuntime, sharedPtr);
            jsiRuntime.global().setProperty(jsiRuntime,"__nativeTornadorMMKV",move(nativeObject));
        }
    }
};

jint JNI_OnLoad(JavaVM* vm, void* reserved)
{
    return jni::initialize(vm,[]{
        TornadorMMKVModule::registerNatives();
    });
}
void JNI_OnUnload(JavaVM* vm, void* reserved)
{

}











