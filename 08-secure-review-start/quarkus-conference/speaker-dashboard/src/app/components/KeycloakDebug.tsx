import React from 'react';
import { useKeycloak } from '@react-keycloak/web';
import { Card, CardBody, CardHeader, CardTitle, Text, TextVariants } from '@patternfly/react-core';

export const KeycloakDebug: React.FC = () => {
  const { keycloak, initialized } = useKeycloak();

  return (
    <Card>
      <CardHeader>
        <CardTitle>Keycloak Debug Info</CardTitle>
      </CardHeader>
      <CardBody>
        <Text component={TextVariants.p}>
          <strong>Initialized:</strong> {initialized ? 'Yes' : 'No'}
        </Text>
        <Text component={TextVariants.p}>
          <strong>Authenticated:</strong> {keycloak.authenticated ? 'Yes' : 'No'}
        </Text>
        <Text component={TextVariants.p}>
          <strong>Token:</strong> {keycloak.token ? `${keycloak.token.substring(0, 20)}...` : 'No token'}
        </Text>
        <Text component={TextVariants.p}>
          <strong>Token Parsed:</strong> {keycloak.tokenParsed ? JSON.stringify(keycloak.tokenParsed, null, 2) : 'No token parsed'}
        </Text>
        <Text component={TextVariants.p}>
          <strong>User:</strong> {keycloak.user?.username || 'No user'}
        </Text>
        <Text component={TextVariants.p}>
          <strong>Realm:</strong> {keycloak.realm || 'No realm'}
        </Text>
      </CardBody>
    </Card>
  );
};
