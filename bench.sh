bun run build.ts && \

pm2 start ecosystem.config.js --only elysia && \
sleep 3 && \
oha -z 10s -m POST -T application/json -d '{"name": "John Doe"}' -o results/elysia.txt http://localhost:3000 && \
pm2 delete ecosystem.config.js --only elysia && \
sleep 3 && \

pm2 start ecosystem.config.js --only hono && \
sleep 3 && \
oha -z 10s -m POST -T application/json -d '{"name": "John Doe"}' -o results/hono.txt http://localhost:3001 && \
pm2 delete ecosystem.config.js --only hono && \
sleep 3 && \

pm2 start ecosystem.config.js --only express && \
sleep 3 && \
oha -z 10s -m POST -T application/json -d '{"name": "John Doe"}' -o results/express.txt http://localhost:3002 && \
pm2 delete ecosystem.config.js --only express && \
sleep 3 && \

pm2 start ecosystem.config.js --only fastify && \
sleep 3 && \
oha -z 10s -m POST -T application/json -d '{"name": "John Doe"}' -o results/fastify.txt http://localhost:3003 && \
pm2 delete ecosystem.config.js --only fastify && \
sleep 3 && \

pm2 start ecosystem.config.js --only aspnet-core && \
sleep 3 && \
oha -z 10s -m POST -T application/json -d '{"name": "John Doe"}' -o results/aspnet-core.txt http://localhost:3004 && \
pm2 delete ecosystem.config.js --only aspnet-core && \
sleep 3 && \

pm2 start ecosystem.config.js --only go && \
sleep 3 && \
oha -z 10s -m POST -T application/json -d '{"name": "John Doe"}' -o results/go.txt http://localhost:3005 && \
pm2 delete ecosystem.config.js --only go && \
sleep 3 && \

pm2 start ecosystem.config.js --only rust && \
sleep 3 && \
oha -z 10s -m POST -T application/json -d '{"name": "John Doe"}' -o results/rust.txt http://localhost:3006 && \
pm2 delete ecosystem.config.js --only rust && \
sleep 3 && \

echo 'Done'
