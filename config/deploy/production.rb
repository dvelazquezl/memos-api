server 'tfg-api.ddns.net', user: 'heisenberg', roles: %w[app db web]

set :ssh_options, {
  forward_agent: true,
  auth_methods: %w[publickey],
  keys: %w[~/.ssh/id_rsa]
}
