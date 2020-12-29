def tenant_scope(tenant)
  Tenant.current = tenant
  put select_tenant_path(tenant)
end