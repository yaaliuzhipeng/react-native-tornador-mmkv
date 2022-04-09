declare type valueType = boolean | number | string;
//declared global object : __nativeTornadorMMKV
declare const __nativeTornadorMMKV:{
    bool:number // 1
    double:number
    i32:number
    i64:number
    ui32:number
    ui64:number
    getValue: (id:string|undefined,key:string,itype:number) => valueType
    setValue: (id:string|undefined,value:any,key:string,itype:number) => boolean
    containsKey: (id:string|undefined,key:string) => boolean
    removeValue: (id:string|undefined,key:string) => void
    allKeys: (id:string|undefined) => Array<string>
    clear: (id:string|undefined) => void
}
