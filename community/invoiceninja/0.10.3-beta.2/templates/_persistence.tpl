{{- define "invoiceninja.persistence" -}}
persistence:
  public:
    enabled: true
    type: pvc
    targetSelector:
      invoiceninja:
        invoiceninja:
          mountPath: /var/www/app/public
      nginx:
        nginx:
          mountPath: /var/www/app/public
  data:
    enabled: true
    {{- include "ix.v1.common.app.storageOptions" (dict "storage" .Values.inStorage.data) | nindent 4 }}
    targetSelector:
      mariadb:
        mariadb:
          mountPath: /todo
  storage:
    enabled: true
    {{- include "ix.v1.common.app.storageOptions" (dict "storage" .Values.inStorage.storage) | nindent 4 }}
    targetSelector:
      invoiceninja:
        invoiceninja:
          mountPath: /var/www/app/storage
      nginx:
        nginx:
          mountPath: /var/www/app/storage

  {{- range $idx, $storage := .Values.inStorage.additionalStorages }}
  {{ printf "in-%v:" (int $idx) }}
    enabled: true
    {{- include "ix.v1.common.app.storageOptions" (dict "storage" $storage) | nindent 4 }}
    targetSelector:
      invoiceninja:
        invoiceninja:
          mountPath: {{ $storage.mountPath }}
      nginx:
        nginx:
          mountPath: {{ $storage.mountPath }}
  {{- end }}
  nginx-cert:
    enabled: true
    type: secret
    objectName: invoiceninja-cert
    defaultMode: "0600"
    items:
      - key: tls.key
        path: private.key
      - key: tls.crt
        path: public.crt
    targetSelector:
      nginx:
        nginx:
          mountPath: /etc/nginx-certs
          readOnly: true
  nginx-conf:
    enabled: true
    type: configmap
    objectName: nginx
    defaultMode: "0600"
    items:
      - key: nginx.conf
        path: nginx.conf
    targetSelector:
      nginx:
        nginx:
          mountPath: /etc/nginx
          readOnly: true

{{- end -}}