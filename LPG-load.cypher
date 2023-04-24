LOAD CSV WITH HEADERS FROM 'https://raw.githubusercontent.com/Anita-Lavania/neosemantics/main/dummy.csv' AS row
WITH row.source_uri AS source_uri, row.source_name AS source_name, row.edge AS edge, row.target_uri AS target_uri, row.target_name AS target_name
MERGE (se:Entity {entity_uri: source_uri})
    SET se.name = source_name
MERGE (te:Entity {entity_uri: target_uri})
    SET te.name = target_name
MERGE (se)-[:RELATED {name: edge}]->(te)
