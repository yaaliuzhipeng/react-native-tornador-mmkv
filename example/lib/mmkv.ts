import {NativeModules} from 'react-native';
const {TornadorMMKV} = NativeModules;

export const __install:() => void = () => {
    if(global.__nativeTornadorMMKV == undefined && TornadorMMKV?.install ){
        TornadorMMKV.install();
    }// already installed
};

enum MMKVType {
  bool = 1,
  double,
  i32,
  i64,
  ui32,
  ui64,
}
const MMKV = {
  type: MMKVType,
  getValue: (key: string, itype?: MMKVType, id?: string) => {
    return __nativeTornadorMMKV.getValue(id, key, itype ?? -1);
  },
  setValue: (value: any, key: string, itype?: MMKVType, id?: string) => {
    return __nativeTornadorMMKV.setValue(id, value, key, itype ?? -1);
  },
  containsKey: (key: string, id?: string) => {
    return __nativeTornadorMMKV.containsKey(id, key);
  },
  removeValue: (key: string, id?: string) => {
    return __nativeTornadorMMKV.removeValue(id, key);
  },
  allKeys: (id?: string) => {
    return __nativeTornadorMMKV.allKeys(id);
  },
  clear: (id?: string) => {
    __nativeTornadorMMKV.clear(id);
  },
};
export default MMKV;
