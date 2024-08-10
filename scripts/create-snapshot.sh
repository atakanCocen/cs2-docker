SERVICE_NAME=${1:-"cs2-server"}
VOLUME_NAME=cs2-install
VOLUME_ID=$(aws ec2 describe-volumes --filters "Name=tag:aws:ecs:serviceName,Values=$SERVICE_NAME" --query 'Volumes[*].VolumeId' --output text)

echo "Creating snapshot for volume $VOLUME_ID"
aws ec2 create-snapshot --volume-id $VOLUME_ID --description "Counter-Strike 2 Install Snapshot" --tag-specifications "ResourceType=snapshot,Tags=[{Key=Name,Value=$VOLUME_NAME}]"
