import React, { useEffect, useState } from 'react';
import { View, Text, StyleSheet } from 'react-native';
import MMKV from './lib';

const Button = (props) => {
	return (
		<Text onPress={props.onPress} style={styles.label_btn}>{props.label}</Text>
	)
}

const App = (props) => {

	const [value,setvalue]:any[] = useState('');

	return (
		<View style={[styles.container]}>
			<Text style={{fontSize:23,color:'#999',marginVertical:20}}>{"VALUE => "+value}</Text>
			<Button
				onPress={() => {
					MMKV.setValue(Math.round(Math.random()*1000), "count", MMKV.type.i32);
				}}
				label={'set value for key: count'}
			/>
			<Button
				onPress={() => {
					setvalue(MMKV.getValue("count", MMKV.type.i32))
				}}
				label={'get value from key: count'}
			/>
		</View>
	)
}
export default App

const styles = StyleSheet.create({
	container: {
		flex: 1,
		justifyContent: 'center',
		alignItems: 'center'
	},
	label_btn: {
		fontSize: 18,
		color: '#1459B2',
		marginVertical:10,
	}
})