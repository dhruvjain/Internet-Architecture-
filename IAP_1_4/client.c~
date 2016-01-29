#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <errno.h>
#include <string.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <netdb.h>
#define MAXBUFLEN 100
int main(int argc, char *argv[])
{
	int sockfd;
	int MYPORT;
	printf("Enter port\n");
	scanf("%d",&MYPORT);
	struct sockaddr_in their_addr; // connector’s address information
	struct sockaddr_in serv_addr;
	struct hostent *he;
	int numbytes;
	char buf[MAXBUFLEN];
	if (argc != 3) {
		fprintf(stderr,"usage: talker hostname message\n");
		exit(1);
	}
	if ((he=gethostbyname(argv[1])) == NULL) {  // get the host info
		perror("gethostbyname");
		exit(1);
	}
	if ((sockfd = socket(AF_INET, SOCK_DGRAM, 0)) == -1) {
		perror("socket");
		exit(1);
	}
	their_addr.sin_family = AF_INET;     // host byte order
	their_addr.sin_port = htons(MYPORT); // short, network byte order
	their_addr.sin_addr = *((struct in_addr *)he->h_addr);
	int addr_len = sizeof(struct sockaddr);
	struct timeval tv;

	tv.tv_sec = 3;  /* 30 Secs Timeout */
	tv.tv_usec = 0;  // Not init'ing this can cause strange errors

	setsockopt(sockfd, SOL_SOCKET, SO_RCVTIMEO, (char *)&tv,sizeof(struct timeval)); // set time out for rcvfrom
	while(1){
		memset(&(their_addr.sin_zero), '\0', 8); // zero the rest of the struct
		if ((numbytes=sendto(sockfd, argv[2], strlen(argv[2]), 0,(struct sockaddr *)&their_addr, sizeof(struct sockaddr))) == -1) {
			perror("sendto");
			exit(1);
		}
		printf("\n\nsent %d bytes to %s\n\n", numbytes,inet_ntoa(their_addr.sin_addr));

		if ((numbytes=recvfrom(sockfd,buf, MAXBUFLEN-1, 0,(struct sockaddr *)&serv_addr, &addr_len)) == -1) {
			//perror("recvfrom");			
		}

		printf("got packet from %s\n",inet_ntoa(their_addr.sin_addr));
		printf("packet is %d bytes long\n",numbytes);
		buf[numbytes] = '\0';
		printf("packet contains \"%s\"\n",buf);
		sleep(1);
	}
	close(sockfd);
	return 0;
}
