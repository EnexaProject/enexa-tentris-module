# Don't change this file! It is generated based on Dockerfile.template.
FROM hub.cs.upb.de/enexa/images/enexa-utils:1 AS utils
#FROM dicegroup/tentris_server:0.3.0-SNAPSHOT AS tentris
FROM busybox:1.36.1

WORKDIR /app

# Add enexa-utils
COPY --from=utils / /


COPY tentris_server /app/tentris_server

# Add Tentris
#COPY --from=tentris /tentris_server /app/tentris_server
#COPY --from=tentris /tentris_terminal /app/tentris_terminal
#COPY --from=tentris /ids2hypertrie /app/ids2hypertrie
#COPY --from=tentris /rdf2ids /app/rdf2ids

# Add module script
COPY module /app/module

# Run
ENTRYPOINT ["./module"]
