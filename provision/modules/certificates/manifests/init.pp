# Class: certificates
#
#
class certificates {
  
  if $::operatingsystem == 'windows' {
    exec { 'remove_dupilcate_cert_thwarte':
      command   => 'CertUtil -delstore Root BE36A4562FB2EE05DBB3D32323ADF445084ED656',
      path      => 'c:/Windows/System32',
      logoutput => true,
      #refreshonly => true,
      creates   => 'c:/thwarte_removed.txt',
    }

    file { 'c:/thwarte_removed.txt':
      ensure  => file,
      content => 'true',
      require => Exec [ 'remove_dupilcate_cert_thwarte' ],
    }
  }
}


# $store = New-Object System.Security.Cryptography.X509Certificates.X509Store “Root”
# $store.Open(“ReadWrite”)
# foreach ($certi in $store.Certificates){if ($certi.friendlyname -eq 'thawte' -AND $certi.Thumbprint -eq 'BE36A4562FB2EE05DBB3D32323ADF445084ED656'){$certi}}
# foreach ($certi in $store.Certificates){if ($certi.friendlyname -eq 'thawte' -AND $certi.Thumbprint -eq 'BE36A4562FB2EE05DBB3D32323ADF445084ED656'){$store.Remove($certi)} }
# foreach ($certi in $store.Certificates){if ($certi.friendlyname -eq 'thawte' -AND $certi.Thumbprint -eq 'BE36A4562FB2EE05DBB3D32323ADF445084ED656'){$certi}}