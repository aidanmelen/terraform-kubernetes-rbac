package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestTerraformRBACExample(t *testing.T) {
	terraformOptions := &terraform.Options{
		// website::tag::1:: Set the path to the Terraform code that will be tested.
		TerraformDir: "../examples/rbac",

		// Disable colors in Terraform commands so its easier to parse stdout/stderr
		NoColor: true,
	}

	// website::tag::4:: Clean up resources with "terraform destroy" at the end of the test.
	defer terraform.Destroy(t, terraformOptions)

	// website::tag::2:: Run "terraform init" and "terraform apply". Fail the test if there are any errors.
	terraform.InitAndApply(t, terraformOptions)

	type moduleRBAC struct {
		Somebool    bool
		Somefloat   float64
		Someint     int
		Somestring  string
		Somemap     map[string]interface{}
		Listmaps    []map[string]interface{}
		Liststrings []string
	}

	// website::tag::3:: Run `terraform output` to get the values of output variables and check they have the expected values.
	outputPodReader := terraform.OutputMap(t, terraformOptions, "pod_reader")
	outputSecretReader := terraform.OutputMap(t, terraformOptions, "secret_reader")
	outputSecretReaderGlobal := terraform.OutputMap(t, terraformOptions, "secret_reader_global")
	outputClusterAdmin := terraform.OutputMap(t, terraformOptions, "cluster_admin")

	expectedPodReader := map[string]string(map[string]string{"cluster_role_binding_name": "<nil>", "cluster_role_name": "<nil>", "role_binding_name": "read-pods", "role_binding_namespace": "default", "role_name": "pod-reader", "role_namespace": "default"})
	expectedSecretReader := map[string]string(map[string]string{"cluster_role_binding_name": "<nil>", "cluster_role_name": "secret-reader", "role_binding_name": "read-secret", "role_binding_namespace": "development", "role_name": "<nil>", "role_namespace": "<nil>"})
	expectedSecretReaderGlobal := map[string]string(map[string]string{"cluster_role_binding_name": "read-secrets-global", "cluster_role_name": "secret-reader-global", "role_binding_name": "<nil>", "role_binding_namespace": "<nil>", "role_name": "<nil>", "role_namespace": "<nil>"})
	expectedClusterAdmin := map[string]string(map[string]string{"cluster_role_binding_name": "cluster-admin-global", "cluster_role_name": "cluster-admin", "role_binding_name": "<nil>", "role_binding_namespace": "<nil>", "role_name": "<nil>", "role_namespace": "<nil>"})

	assert.Equal(t, expectedPodReader, outputPodReader, "Map %q should match %q", outputPodReader, expectedPodReader)
	assert.Equal(t, expectedSecretReader, outputSecretReader, "Map %q should match %q", outputSecretReader, expectedSecretReader)
	assert.Equal(t, expectedSecretReaderGlobal, outputSecretReaderGlobal, "Map %q should match %q", outputSecretReaderGlobal, expectedSecretReaderGlobal)
	assert.Equal(t, expectedClusterAdmin, outputClusterAdmin, "Map %q should match %q", outputClusterAdmin, expectedClusterAdmin)

	// website::tag::4:: Run a second "terraform apply". Fail the test if results have changes
	terraform.ApplyAndIdempotent(t, terraformOptions)
}
