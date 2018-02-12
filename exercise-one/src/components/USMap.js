import React from 'react';
import * as d3 from 'd3';
import { US_STATE_NAME_MAP } from '../constants';

export default class USMap extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      loading: true,
      stateData: {},
      stateLoans: []
    };
  }

  componentDidMount() {
    const { geoData, stateData } = this.props;

    if (geoData) {
      const topojson = window.topojson;
      const { states, average_funded } = stateData;
      const svg = d3.select('svg');
      const path = d3.geoPath();

      // credit is where credit is due: http://bl.ocks.org/NPashaP/a74faf20b492ad377312
      // draw the states, colorize by average funding verus the state funding amount
      svg.select("g")
        .attr("class", "states")
        .selectAll("path")
        .data(topojson.feature(geoData, geoData.objects.states).features)
        .enter().append("path")
        .attr("d", path)
        .attr("fill", datum => {
          const usState = US_STATE_NAME_MAP[datum.id];
          const usStateData = states.find(s => usState.abbrev === s.state);
          return d3.interpolate("#ffffcc", "#800026")(usStateData.average / average_funded);
        })
        .on('mouseover', this.props.handleStateMouseOver);

      svg.append("path")
          .attr("class", "borders")
          .attr("d", path(topojson.mesh(geoData, geoData.objects.states, (a, b) => a !== b)));
    }
  }

  render() {
    return (
      <g id='state-map'></g>
    );
  }
}
