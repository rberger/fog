module Fog
  module AWS
    class Compute
      class Real

        require 'fog/compute/parsers/aws/request_spot_instances'

        # Request specified spot instances
        #
        # ==== Parameters
        # * spot_price<~String> - The maximum hourly price for any Spot
        #   Instance launched to fulfill the request.
        # * instance_count<~Integer> -The maximum number of Spot Instances to launch.
        #   Default: 1
        # * type<~String> - Spot Instance request type. Valid values: one-time | persistent
        #   Default: one-time
        # * valid_from<~DateTime> - Start date of the request. If this 
        #   is a one-time request, the request becomes active at this 
        #   date and time and remains active until all instances launch, 
        #   the request expires, or the request is canceled. If the request 
        #   is persistent, the request becomes active at this date and time 
        #   and remains active until it expires or is canceled.
        #   Default: Request is effective independently
        # * valid_until<~DateTime> - End date of the request. If this is a 
        #   one-time request, the request remains active until all instances 
        #   launch, the request is canceled, or this date is reached. If 
        #   the request is persistent, it remains active until it is canceled
        #   or this date and time is reached. Default: Request is effective indefinitely
        # * launch_group<~String> - The instance launch group. Launch groups 
        #   are Spot Instances that launch together and terminate together.
        #   Default: Instances are launched and terminated individually
        # * availability_zone_group<~String> - The Availability Zone group. 
        #   If you specify the same Availability Zone group for all Spot Instance 
        #   requests, all Spot Instances are launched in the same Availability Zone.
        #   Default: Instances are launched in any available Availability Zone.
        # * launch_specification<~Hash>:
        #   * 'ImageId'<~String> - The AMI ID.
        #   * 'KeyName'<~String> - The name of the key pair.
        #   * 'SecurityGroupId'<~Array> or <~String> - ID of the security group. 
        #     You can use either this field or the 'SecurityGroup' to specify a security group.
        #     Default: The instance uses the default security group
        #   * 'SecurityGroup'<~Array> or <~String> - Name of the security group. 
        #     Can use this instead of 'SecurityGroupId'
        #     Default: The instance uses the default security group
        #   * 'UserData'<~String> - MIME, Base64-encoded user data to make available 
        #      to the instances.
        #   * 'InstanceType'<~String> - The instance type. Valid Values:  m1.small | 
        #     m1.large | m1.xlarge | c1.medium | c1.xlarge | m2.xlarge | m2.2xlarge | 
        #     m2.4xlarge | t1.micro Default: m1.small
        #   * 'Placement.AvailabilityZone'<~String> - The placement constraints 
        #     (Availability Zone) for launching the instances.
        #     Default: Amazon EC2 selects an Availability Zone.
        #   * 'KernelId'<~String> - The ID of the kernel to select.
        #   * 'RamdiskId'<~String> - The ID of the RAM disk to select. 
        #     Some kernels require additional drivers at launch.
        #     Check the kernel requirements for information on whether you 
        #     need to specify a RAM disk and search for the kernel ID.
        #   * 'BlockDeviceMapping'<~Array>: array of hashes
        #     * 'DeviceName'<~String> - where the volume will be exposed to instance
        #     * 'VirtualName'<~String> - volume virtual device name
        #     * 'Ebs.SnapshotId'<~String> - id of snapshot to boot volume from
        #     * 'Ebs.VolumeSize'<~Integer> - size of volume in GiBs required unless snapshot is specified
        #     * 'Ebs.NoDevice'<~Boolean> - Specifies that no device should be mapped.
        #       Default: true
        #     * 'Ebs.DeleteOnTermination'<~String> - specifies whether or not to delete 
        #       the volume on instance termination. Default: true
        #    * 'Monitoring.Enabled'<~Boolean> - Enables monitoring for the instance. 
        #      Default: Disabled
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'requestId'<~String> - The ID of the request.
        #     * 'spotInstanceRequestSet'<~Array>: Information about the Spot Instance request
        #       * spot_instance_request<~Hash>:
        #         * 'spotInstanceRequestId'<~String> - The ID of the Spot Instance request.
        #         * 'spotPrice'<~String> - The maximum hourly price for any Spot Instance 
        #           launched to fulfill the request.
        #         * 'type'<~String> - The Spot Instance request type. 
        #           Valid Values: one-time | persistent
        #         * 'state'<~String> - The state of the Spot Instance request.
        #           Valid Values: open | closed | cancelled | failed
        #         * 'fault'<~Hash>: Fault codes for the Spot Instance request, if any.
        #           * 'code'<~String> - Reason code for the Spot Instance state change
        #           * 'message'<~String> - Message for the Spot Instance state change.
        #         * 'validFrom'<~DateTime> - Start date of the request. If this is a 
        #           one-time request, the request becomes active at this date and time
        #           and remains active until all instances launch, the request expires,
        #           or the request is canceled. If the request is persistent, 
        #           the request becomes active at this date and time and remains active 
        #           until it expires or is canceled.
        #         * 'validUntil'<~DateTime> - End date of the request. If this is a
        #           one-time request, the request remains active until all instances 
        #           launch, the request is canceled, or this date is reached. If the 
        #           request is persistent, it remains active until it is canceled or 
        #           this date is reached.
        #         * 'launchGroup'<~String> - The instance launch group. Launch groups
        #           are Spot Instances that launch together and terminate together.
        #         * 'availabilityZoneGroup'<~String> - The Availability Zone group. 
        #           If you specify the same Availability Zone group for all Spot 
        #           Instance requests, all Spot Instances are launched in the same
        #           Availability Zone.
        #         * 'launchedAvailabilityZone'<~String> - The Availability Zone in 
        #           which the bid is launched.
        #         * 'launchSpecification'<~Hash>: Additional information for launching instances.
        #           * 'imageId'<~String> - image id of ami used to launch instance
        #           * 'keyName'<~String> - name of key used launch instances or blank
        #           * 'groupSet'<~Array>: groups the instances are members in
        #             * 'groupName'<~String> - Name of group
        #           * 'instanceType'<~String> - type of instance
        #           * 'placement'<~Hash>:
        #             * 'availabilityZone'<~String> - Availability zone of the instance
        #           * 'kernelId'<~String> - Id of kernel used to launch instance
        #           * 'ramdiskId'<~String> - Id of ramdisk used to launch instance
        #           * 'blockDeviceMapping'<~Array>
        #             * 'deviceName'<~String> - The device name (e.g., /dev/sdh).
        #             * 'virtualName'<~String> - The virtual device name.
        #             * 'ebs'<~Hash>: Parameters used to automatically set up Amazon 
        #               EBS volumes when the instance is launched.
        #               * 'snapshotId'<~String> - The ID of the snapshot.
        #               * 'volumeSize'<~Integer> - The size of the volume, in GiBs.
        #                 If you're specifying a block device mapping, this is required
        #                 if you're not creating a volume from a snapshot.
        #               * 'deleteOnTermination'<~Boolean> - Whether the Amazon EBS volume 
        #                 is deleted on instance termination.
        #             *  'noDevice'<~Boolean> - Include this empty element to indicate 
        #                that you want to suppress the specified device from the mapping.
        #           * 'monitoring'<~Hash> Whether to enable monitoring for the instance.
        #             * 'enabled'<~Boolean> - Whether monitoring is enabled for the instance
        #           * 'subnetId'<~String> - The Amazon VPC subnet ID within which to
        #             launch the instance(s) for Amazon Virtual Private Cloud.
        #         * 'instanceId'<~String> - The instance ID, if an instance has been 
        #           launched to fulfill the Spot Instance request.
        #         * 'createTime'<~DateTime> - Time stamp when the Spot Instance request was created.
        #         * 'productDescription'<~String> - The product description associated 
        #           with the Spot Instance.
        #         * 'tagSet'<~Array> of <~Hash>: Tags assigned to the resource.
        #           * 'key'<~String> - Key
        #           * 'value'<~String< - Value
                
        
        # {Amazon API Reference}[http://docs.amazonwebservices.com/AWSEC2/latest/APIReference/index.html?ApiReference-query-RequestSpotInstances.html]
        def request_spot_instances(image_id, min_count, max_count, options = {})
          if block_device_mapping = options.delete('BlockDeviceMapping')
            block_device_mapping.each_with_index do |mapping, index|
              for key, value in mapping
                options.merge!({ format("BlockDeviceMapping.%d.#{key}", index) => value })
              end
            end
          end
          if security_groups = options.delete('SecurityGroup')
            options.merge!(AWS.indexed_param('SecurityGroup', [*security_groups]))
          end
          if options['UserData']
            options['UserData'] = Base64.encode64(options['UserData'])
          end

          idempotent = !(options['ClientToken'].nil? || options['ClientToken'].empty?)

          request({
            'Action'    => 'RunInstances',
            'ImageId'   => image_id,
            'MinCount'  => min_count,
            'MaxCount'  => max_count,
            :idempotent => idempotent,
            :parser     => Fog::Parsers::AWS::Compute::RequestSpotInstances.new
          }.merge!(options))
        end

      end

      class Mock

        def request_spot_instances(image_id, min_count, max_count, options = {})
          response = Excon::Response.new
          response.status = 200

          group_set = [ (options['SecurityGroup'] || 'default') ].flatten
          instances_set = []
          reservation_id = Fog::AWS::Mock.reservation_id

          if options['KeyName'] && describe_key_pairs('key-name' => options['KeyName']).body['keySet'].empty?
            raise Fog::AWS::Compute::NotFound.new("The key pair '#{options['KeyName']}' does not exist")
          end

          min_count.times do |i|
            instance_id = Fog::AWS::Mock.instance_id
            instance = {
              'amiLaunchIndex'      => i,
              'blockDeviceMapping'  => [],
              'clientToken'         => options['clientToken'],
              'dnsName'             => nil,
              'imageId'             => image_id,
              'instanceId'          => instance_id,
              'instanceState'       => { 'code' => 0, 'name' => 'pending' },
              'instanceType'        => options['InstanceType'] || 'm1.small',
              'kernelId'            => options['KernelId'] || Fog::AWS::Mock.kernel_id,
              'keyName'             => options['KeyName'],
              'launchTime'          => Time.now,
              'monitoring'          => { 'state' => options['Monitoring.Enabled'] || false },
              'placement'           => { 'availabilityZone' => options['Placement.AvailabilityZone'] || Fog::AWS::Mock.availability_zone(@region) },
              'privateDnsName'      => nil,
              'productCodes'        => [],
              'ramdiskId'           => options['RamdiskId'] || Fog::AWS::Mock.ramdisk_id,
              'reason'              => nil,
              'rootDeviceType'      => 'instance-store'
            }
            instances_set << instance
            self.data[:instances][instance_id] = instance.merge({
              'architecture'        => 'i386',
              'groupSet'            => group_set,
              'ownerId'             => self.data[:owner_id],
              'privateIpAddress'    => nil,
              'reservationId'       => reservation_id,
              'stateReason'         => {},
              'tagSet'              => {}
            })
          end
          response.body = {
            'groupSet'      => group_set,
            'instancesSet'  => instances_set,
            'ownerId'       => self.data[:owner_id],
            'requestId'     => Fog::AWS::Mock.request_id,
            'reservationId' => reservation_id
          }
          response
        end

      end
    end
  end
end
