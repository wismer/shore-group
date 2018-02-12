import React from 'react';
import { Table, Label } from 'semantic-ui-react';

const StateTooltipRow = props => {
  return (
    <Table.Row>
      <Table.Cell>
        <Label>{props.grade}</Label>
      </Table.Cell>
      <Table.Cell>{props.count}</Table.Cell>
    </Table.Row>
  );
};

const StateTooltip = props => {
  const stateData = props.by_grade.map((grade, key) => <StateTooltipRow key={key} {...grade} />);
  return (
    <div>

      <Table celled id='tooltip'>
        <p>{props.state} (Average Funded: ${Math.floor(props.average)})</p>
        GRADE
        <Table.Body>
          {stateData}
        </Table.Body>
      </Table>
    </div>
  );
};

export default StateTooltip;
