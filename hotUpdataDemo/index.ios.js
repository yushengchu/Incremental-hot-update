/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 * @flow
 */

import React, { Component } from 'react';
import {
  AppRegistry,
  StyleSheet,
  Text,
  View,
  Image,
  Dimensions,
} from 'react-native';

const SCREEN_WIDTH = Dimensions.get('window').width;
const SCREEN_HEIGHT = Dimensions.get('window').height;

export default class hotUpdataDemo extends Component {
  render() {
    return (
      <View style={styles.container}>
        <Image source={require('./app/assest/346736.jpg')}
               style={{width:SCREEN_WIDTH,height:SCREEN_HEIGHT,justifyContent:'center',alignItems:'center'}}>
          <Text>热更新后----------></Text>
          <Image source={require('./app/assest/shipo.png')} style={{width:100,height:100,marginTop:20}}/>
        </Image>
      </View>
    );
  }
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    backgroundColor: '#F5FCFF',
  },
  welcome: {
    fontSize: 20,
    textAlign: 'center',
    margin: 10,
  },
  instructions: {
    textAlign: 'center',
    color: '#333333',
    marginBottom: 5,
  },
});

AppRegistry.registerComponent('hotUpdataDemo', () => hotUpdataDemo);
