import React, { Component } from 'react';
import './App.css';
import StateTooltip from './components/StateTooltip';
import USMap from './components/USMap';
import { US_STATE_NAME_MAP } from './constants';


class App extends Component {
  constructor() {
    super();
    this.state = {
      activeGraphic: 'chart',
      geoStateData: [],
      stateLoanData: [],
      geoLoaded: false,
      dataLoaded: false,
      activeToolTip: null
    };

    this.stateMouseOver = this.stateMouseOver.bind(this);
    this.changeGraphic = this.changeGraphic.bind(this);
  }

  changeGraphic(graphic = 'chart') {
    this.setState({ activeGraphic: graphic });
  }

  fetchStateJSON() {
    return fetch('us-states.json').then(response => {
      return response.json();
    });
  }

  fetchStateData() {
    return fetch('by-state-loans.json').then(response => {
      return response.json();
    });
  }

  componentDidMount() {
    this.fetchStateJSON().then(geoStateData => {
      this.setState({ geoLoaded: true, geoStateData });
    });

    this.fetchStateData().then(stateLoanData => {
      this.setState({ dataLoaded: true, stateLoanData });
    });
  }

  stateMouseOver(geoState) {
    const usState = US_STATE_NAME_MAP[geoState.id];
    const stateData = this.state.stateLoanData.states.find(s => s.state === usState.abbrev);
    this.setState({ activeToolTip: stateData });
  }

  render() {
    const { geoStateData, geoLoaded, stateLoanData, activeToolTip } = this.state;

    return (
      <div className="App">
        {activeToolTip ? <StateTooltip {...activeToolTip} /> : null}

        <svg width='960' height='800'>
          {geoLoaded ? <USMap handleStateMouseOver={this.stateMouseOver} geoData={geoStateData} stateData={stateLoanData} /> : null}
        </svg>
      </div>
    );
  }
}

export default App;
